import os
import re
import string
import time

import jwt
import json
import random
from django.conf import settings
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.contrib.sites.shortcuts import get_current_site
from django.http import HttpResponsePermanentRedirect
from django.template.loader import render_to_string
from django.urls import reverse
from django.utils.encoding import smart_str, smart_bytes, DjangoUnicodeDecodeError, force_str
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status, permissions
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.parsers import MultiPartParser, FormParser, FileUploadParser
from rest_framework.exceptions import AuthenticationFailed, ValidationError

from .models import Account, Staff, Enterprise
from .renderers import UserRenderer
from .serializers import (
    RegisterSerializer,
    LoginSerializer,
    EmailVerificationSerializer,
    LogoutSerializer,
    PasswordResetSerializer,
    PasswordCofirmationSerializer,
    EmailValidationCodeSerializer,
    VerificationCodeSerializer,
    StaffSerializer,
    RegisterEnterpriseSerializer,
    AccountProfileSettingsSerializer,
)

# Register API class
from .utlis import SendUserEmail
from ..analytics.mixins import LoggingMixin
from ..assessment.models import Assessment
from ..assessment.serializers import AssessmentSerializer
from ..consumer_request.models import ConsumerRequest
from ..consumer_request.serializers import ConsumerRequestSerializer
from ..enterprise.models import EnterpriseConfigurationModel
from ..enterprise.serializers import EnterpriseConfigurationSerializer


class CustomRedirect(HttpResponsePermanentRedirect):
    allowed_schemes = ["http", "https"]


def generate_random_email():
    letters = string.ascii_lowercase[:12]
    first_part = "".join(random.choice(letters) for i in range(10))
    second_part = "".join(random.choice(letters) for i in range(6))
    return f"{first_part}_{time.time()}@{second_part}.elroi.user"


class RegisterStaff(LoggingMixin, GenericAPIView):
    serializer_class = StaffSerializer
    renderer_classes = (UserRenderer, )

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid(raise_exception=True):
            staff_data = serializer.save()
            account = Account.objects.get(email__iexact=staff_data.email)
            token = RefreshToken.for_user(account).access_token
            activate_url = f"{settings.FRONTEND_URL}/email-confirm/{str(token)}"
            message_body = render_to_string(
                "email/activate_account.html", {
                    "user_full_name": account.full_name(),
                    "url": activate_url
                })
            email_data = {
                "email_body": message_body,
                "to_email": account.email,
                "email_subject": "Activate your account",
            }
            SendUserEmail.send_email(email_data)
            return Response(
                {
                    "user": {
                        "elroi_id": staff_data.elroi_id,
                        "email": staff_data.email,
                        "first_name": staff_data.first_name,
                        "last_name": staff_data.last_name,
                        "full_name": staff_data.full_name(),
                        "two_fa_valid": account.is_2fa_on(),
                        "profile": staff_data.profile(),
                    },
                    "token": account.tokens(),
                },
                status=status.HTTP_201_CREATED,
            )
        else:
            return Response(serializer.errors,
                            status=status.HTTP_400_BAD_REQUEST)


class RegisterEnterprise(LoggingMixin, GenericAPIView):
    serializer_class = RegisterEnterpriseSerializer
    renderer_classes = (UserRenderer, )

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            serializer.save()
            enterprise_data = serializer.data
            account = Account.objects.get(
                email__iexact=enterprise_data["email"])
            enterprise = account.enterprise
            token = RefreshToken.for_user(account).access_token
            activate_url = f"{settings.FRONTEND_URL}/email-confirm/{str(token)}"
            message_body = render_to_string(
                "email/activate_account.html", {
                    "user_full_name": account.full_name(),
                    "url": activate_url
                })
            email_data = {
                "email_body": message_body,
                "to_email": account.email,
                "email_subject": "Activate your account",
            }
            SendUserEmail.send_email(email_data)
            return Response(
                {
                    "user": {
                        "elroi_id": enterprise.elroi_id,
                        "email": enterprise.email,
                        "name": enterprise.name,
                        "first_name": enterprise.first_name,
                        "last_name": enterprise.last_name,
                        "full_name": enterprise.full_name(),
                        "web": enterprise.web,
                        "two_fa_valid": account.is_2fa_on(),
                        "profile": enterprise.profile(),
                    },
                    "token": account.tokens(),
                },
                status=status.HTTP_201_CREATED,
            )
        else:
            return Response(serializer.errors,
                            status=status.HTTP_400_BAD_REQUEST)


class VerifyEmailAPI(LoggingMixin, APIView):
    serializer_class = EmailVerificationSerializer
    token_param_config = openapi.Parameter(
        "token",
        in_=openapi.IN_QUERY,
        description="Email Verification",
        type=openapi.TYPE_STRING,
    )

    @swagger_auto_schema(manual_parameters=[token_param_config])
    def get(self, request):
        token = request.GET.get("token")
        try:
            payload = jwt.decode(token, settings.SECRET_KEY)
            user = Account.objects.get(id=payload["user_id"])
            if not user.is_verified:
                user.is_verified = True
                user.is_active = True
                user.save()
            return Response({"email": "Successfully activated"},
                            status=status.HTTP_200_OK)
        except jwt.ExpiredSignatureError as identifier:
            return Response({"error": "Activation Expired"},
                            status=status.HTTP_400_BAD_REQUEST)
        except jwt.exceptions.DecodeError as identifier:
            return Response({"error": "Invalid token"},
                            status=status.HTTP_400_BAD_REQUEST)


# Login Api class
class LoginAPI(LoggingMixin, GenericAPIView):
    serializer_class = LoginSerializer
    permission_classes = (permissions.AllowAny, )

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        status_response = status.HTTP_200_OK
        user_data = serializer.data

        if not user_data["two_fa_valid"]:
            status_response = status.HTTP_206_PARTIAL_CONTENT
        user = Account.objects.get(email__iexact=user_data["email"])
        if hasattr(user, "staff"):
            account = user.staff
            account_id = "staff_id"
        elif hasattr(user, "enterprise"):
            account = user.enterprise
            account_id = "enterprise_id"
        else:
            account = user
            account_id = "user_id"

        res_data = {
            account_id: account.id,
            "elroi_id": account.elroi_id,
            "email": account.email,
            "full_name": account.full_name(),
            "is_2fa_active": user.is_2fa_active,
            "profile": account.profile(),
            "tokens": user.tokens(),
        }

        return Response(res_data, status=status_response)


# log out current user
class LogoutAPI(LoggingMixin, APIView):
    serializer_class = LogoutSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response({"success": True}, status=status.HTTP_204_NO_CONTENT)


# sent a link to reset password.
class PasswordResetAPI(LoggingMixin, GenericAPIView):
    serializer_class = PasswordResetSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = request.data["email"]
        try:
            if Account.objects.filter(email__iexact=email).exists():
                user = Account.objects.get(email=email)
                uidb64 = urlsafe_base64_encode(smart_bytes(user.id))
                token = PasswordResetTokenGenerator().make_token(user)
                reset_url = f"{settings.FRONTEND_URL}/password-reset/{uidb64}/{token}"
                message_body = render_to_string(
                    "email/password_reset.html", {
                        "user_full_name": user.full_name(),
                        "url": reset_url
                    })
                email_data = {
                    "email_body": message_body,
                    "to_email": user.email,
                    "email_subject": "Reset your password",
                }
                SendUserEmail.send_email(email_data)
                return Response(
                    {
                        "success":
                        True,
                        "message":
                        "Please check your Inbox, we have sent you a link to reset password."
                    },
                    status=status.HTTP_200_OK,
                )
            else:
                return Response(
                    {
                        "success": False,
                        "message": "The email address doesn't exist."
                    },
                    status=status.HTTP_200_OK,
                )
        except:
            return Response(
                {
                    "success": False,
                    "message": "Server error."
                },
                status=status.HTTP_200_OK,
            )


class PasswordConfirmationAPI(GenericAPIView):
    serializer_class = PasswordCofirmationSerializer

    def get(self, request, *args, **kwargs):
        try:
            token = kwargs["token"]
            uidb64 = kwargs["uidb64"]
            id = force_str(urlsafe_base64_decode(uidb64))
            user = Account.objects.get(id=id)
            if not PasswordResetTokenGenerator().check_token(user, token):
                raise Exception("error")
        except:
            return Response({
                "success": False,
                "error": "Invalid link"
            },
                            status=status.HTTP_401_UNAUTHORIZED)
        return Response({
            "success": True,
            "error": None
        },
                        status=status.HTTP_200_OK)

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        try:
            uidb64 = kwargs["uidb64"]
            id = force_str(urlsafe_base64_decode(uidb64))
            user = Account.objects.get(id=id)
            serializer.is_valid(raise_exception=True)
            user.set_password(request.data.get("password"))
            user.save()
            return Response({
                "success": True,
                "error": None
            },
                            status=status.HTTP_200_OK)
        except ValidationError as e:
            return Response({
                "success": False,
                "error": e.detail.get("error")
            },
                            status=status.HTTP_200_OK)


""" This view is used to generate and send verification code"""


class SendValidationCodeAPI(LoggingMixin, APIView):
    serializer_class = EmailValidationCodeSerializer

    permission_classes = (permissions.IsAuthenticated, )

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = request.data["email"]
        if Account.objects.filter(email__iexact=email).exists():
            user = Account.objects.get(email__iexact=email)
            email_template_data = {
                "verification_code": user.verification_code,
                "user_full_name": f"{user.first_name} {user.last_name}",
            }
            message_body = render_to_string("email/verification_code.html",
                                            email_template_data)
            email_data = {
                "email_body": message_body,
                "to_email": user.email,
                "email_subject": "Verification Code",
            }
            SendUserEmail.send_email(email_data)
        return Response(serializer.data, status=status.HTTP_200_OK)


""" This view is used to confirm verification code and update database"""


class VerificationCodeConfirmAPI(APIView):
    serializer_class = VerificationCodeSerializer

    permission_classes = (permissions.IsAuthenticated, )

    def post(self, request):
        serializer = self.serializer_class(data=request.data,
                                           context={"request": request})
        serializer.is_valid(raise_exception=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class AssessmentSharedLink(LoggingMixin, GenericAPIView):
    """
    Display shared assessment by url
    """
    def get(self, request, token, *args, **kwargs):
        try:
            assessment = Assessment.objects.get(share_hash=token)
            return Response(AssessmentSerializer(assessment).data,
                            status=status.HTTP_200_OK)
        except Assessment.DoesNotExist:
            return Response({"error": "Page was not found"},
                            status=status.HTTP_404_NOT_FOUND)


class AccountProfileSettings(LoggingMixin, GenericAPIView):
    """
    Profile account settings
    """

    serializer_class = AccountProfileSettingsSerializer
    permission_classes = (permissions.IsAuthenticated, )
    parser_classes = (MultiPartParser, FormParser, FileUploadParser)

    def get(self, request, *args, **kwargs):
        user = request.user
        return Response(
            AccountProfileSettingsSerializer(user,
                                             context={
                                                 "request": request
                                             }).data,
            status=status.HTTP_200_OK,
        )
        # pass

    def post(self, request, *args, **kwargs):
        user = request.user
        serializer = self.serializer_class(user,
                                           data=request.data,
                                           context={"request": request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors,
                            status=status.HTTP_400_BAD_REQUEST)
