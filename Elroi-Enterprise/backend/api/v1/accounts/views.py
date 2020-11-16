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
from django.utils.encoding import smart_str, smart_bytes, DjangoUnicodeDecodeError
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status, permissions
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.parsers import MultiPartParser, FormParser, FileUploadParser

from .models import Account, Customer, Enterprise
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
    UserSerializer,
    CustomerSerializer,
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


class RegisterCustomer(LoggingMixin, GenericAPIView):
    serializer_class = CustomerSerializer
    renderer_classes = (UserRenderer, )
    parser_classes = (
        MultiPartParser,
        FormParser,
        FileUploadParser,
    )

    def get(self, request, elroi_id, *args, **kwargs):
        try:
            enterprise = Enterprise.objects.get(elroi_id__exact=elroi_id)
            try:
                enterprise_configuration = EnterpriseConfigurationModel.objects.get(
                    enterprise_id=enterprise.id)
                return Response(
                    EnterpriseConfigurationSerializer(
                        enterprise_configuration).data,
                    status=status.HTTP_200_OK,
                )
            except EnterpriseConfigurationModel.DoesNotExist:
                return Response(
                    {"error": "Enterprise was not found"},
                    status=status.HTTP_404_NOT_FOUND,
                )
        except Enterprise.DoesNotExist:
            return Response({"error": "Page was not found"},
                            status=status.HTTP_404_NOT_FOUND)

    def post(self, request, elroi_id, *args, **kwargs):
        try:
            enterprise = Enterprise.objects.get(elroi_id__exact=elroi_id)
            try:
                enterprise_configuration = EnterpriseConfigurationModel.objects.get(
                    enterprise_id=enterprise.id)
                c_dict = json.loads(
                    json.dumps(
                        enterprise_configuration.additional_configuration))
                db_obj = {
                    "email": generate_random_email(),
                    "first_name": "",
                    "last_name": "",
                    "state_resident": "",
                    "additional_fields": {
                        "input": []
                    },
                }
                for item in c_dict["input"]:
                    if item["type"] == "email":
                        db_obj["email"] = request.data.get(item["name"])
                    elif "email" in item["name"]:
                        db_obj["email"] = request.data.get(item["name"])

                    if item["type"] == "file":
                        file = request.FILES[item["name"]]
                        open(os.path.join(settings.UPLOAD_FOLDER, file.name),
                             "wb").write(file.file.read())
                        db_obj["file"] = file.name
                        file_uploaded = {
                            "type": "file",
                            "name": item["name"],
                            "label": item["label"],
                            "value": file.name,
                        }
                        db_obj["additional_fields"]["input"].append(
                            file_uploaded)
                    else:
                        if item["name"] == "first_name":
                            db_obj["first_name"] = request.data.get(
                                item["name"])
                        if item["name"] == "last_name":
                            db_obj["last_name"] = request.data.get(
                                item["name"])

                        if "resident" in item["name"]:
                            is_resident = request.data.get(item["name"])
                            if is_resident.lower() == "yes":
                                state_resident = True
                            else:
                                state_resident = False
                            db_obj["state_resident"] = state_resident
                        request_data = {
                            "type": item["type"],
                            "name": item["name"],
                            "label": item["label"],
                            "value": request.data.get(item["name"]),
                        }
                        db_obj["additional_fields"]["input"].append(
                            request_data)
                customer = Customer.objects.create(**db_obj)
                db_req_obj = {
                    "enterprise_id": enterprise.id,
                    "customer_id": customer.id,
                    "request_form": db_obj["additional_fields"],
                }
                customer_request = ConsumerRequest.objects.create(**db_req_obj)
                return Response(
                    ConsumerRequestSerializer(customer_request).data,
                    status=status.HTTP_201_CREATED,
                )
            except EnterpriseConfigurationModel.DoesNotExist:
                return Response(
                    {"error": "Enterprise was not found"},
                    status=status.HTTP_404_NOT_FOUND,
                )
        except Enterprise.DoesNotExist:
            return Response({"error": "Page was not found"},
                            status=status.HTTP_404_NOT_FOUND)


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
            message_body = render_to_string("email/activate_account.html", {
                "user": account,
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
        if hasattr(user, "customer"):
            account = user.customer
            account_id = "customer_id"
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
            "two_fa_valid": user.is_2fa_on(),
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
        return Response(status=status.HTTP_204_NO_CONTENT)


# sent a link to reset password.
class PasswordResetAPI(LoggingMixin, GenericAPIView):
    serializer_class = PasswordResetSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = request.data["email"]
        if Account.objects.filter(email__iexact=email).exists():
            user = Account.objects.get(email=email)
            uidb64 = urlsafe_base64_encode(smart_bytes(user.id))
            token = PasswordResetTokenGenerator().make_token(user)
            current_site = get_current_site(request=request).domain
            url = reverse("password_reset_confirmation",
                          kwargs={
                              "uidb64": uidb64,
                              "token": token
                          })
            redirect_url = request.data.get("redirect_url", "")
            reset_link = f"{settings.FRONTEND_URL}/{url}?redirect_url={redirect_url}"
            email_template_data = {
                "protocol": request.scheme,
                "domain": current_site,
                "url": reset_link,
            }
            message_body = render_to_string("email/password_reset.html",
                                            email_template_data)
            email_data = {
                "email_body": message_body,
                "to_email": user.email,
                "email_subject": "Reset your password",
            }
            SendUserEmail.send_email(email_data)
        return Response(
            {
                "success":
                "Please check your Inbox, we have sent you a link to reset password."
            },
            status=status.HTTP_200_OK,
        )


class PasswordConfirmationAPI(GenericAPIView):
    serializer_class = PasswordCofirmationSerializer

    def get(self, request, uidb64, token):
        redirect_url = request.GET.get("redirect_url")
        url_valid_false = f"{settings.FRONTEND_URL}?token_valid=False"
        url_front_valid_false = f"{settings.FRONTEND_URL}?token_valid=False"
        url_valid_true = f"{settings.FRONTEND_URL}?token_valid=True&message=Token Valid&uidb64={uidb64}&token={token}"
        try:
            user_id = smart_str(urlsafe_base64_decode(uidb64))
            user = Account.objects.get(id=user_id)

            if not PasswordResetTokenGenerator().check_token(user, token):
                if len(redirect_url) > 0:
                    return CustomRedirect(url_valid_false)
                else:
                    return CustomRedirect(url_front_valid_false)
            return CustomRedirect(url_valid_true)
        except DjangoUnicodeDecodeError as e:
            if not PasswordResetTokenGenerator().check_token(user=user):
                return CustomRedirect(url_valid_false)


""" This view is used to generate and send verification code"""


class SendValidationCodeAPI(LoggingMixin, APIView):
    serializer_class = EmailValidationCodeSerializer

    # permission_classes = (permissions.IsAuthenticated, )

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
        serializer = self.serializer_class(data=request.data)
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
