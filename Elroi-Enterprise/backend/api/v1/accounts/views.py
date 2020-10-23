import os

import jwt
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

from .models import Account
from .renderers import UserRenderer
from .serializers import (
    RegisterSerializer, LoginSerializer, EmailVerificationSerializer, LogoutSerializer,
    PasswordResetSerializer, PasswordCofirmationSerializer, EmailValidationCodeSerializer, VerificationCodeSerializer
)
# Register API class
from .utlis import SendUserEmail


class CustomRedirect(HttpResponsePermanentRedirect):
    allowed_schemes = [os.environ.get('APP_SCHEME'), 'http', 'https']


class RegisterAPI(GenericAPIView):
    serializer_class = RegisterSerializer
    renderer_classes = (UserRenderer,)

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            user_data = serializer.data
            user = Account.objects.get(email__iexact=user_data['email'])
            token = RefreshToken.for_user(user).access_token
            activate_url = f'{settings.FRONTEND_URL}/email-confirm/{str(token)}'
            message_body = render_to_string(
                'email/activate_account.html',
                {'user': user, 'url': activate_url}
            )
            email_data = {
                'email_body': message_body,
                'to_email': user.email,
                'email_subject': 'Activate your account'
            }
            SendUserEmail.send_email(email_data)
            return Response({
                'user': {
                    'elroi_id': user.elroi_id,
                    'email': user.email,
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                    'full_name': user.full_name(),
                    'two_fa_valid': user.is_2fa_on(),
                    'account_type': user.account_type,
                    'profile': user.profile(),
                    'state_resident': user.state_resident,
                },
                'token': user.tokens()
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class VerifyEmailAPI(APIView):
    serializer_class = EmailVerificationSerializer
    token_param_config = openapi.Parameter(
        'token',
        in_=openapi.IN_QUERY,
        description='Email Verification',
        type=openapi.TYPE_STRING
    )

    @swagger_auto_schema(manual_parameters=[token_param_config])
    def get(self, request):
        token = request.GET.get('token')
        try:
            payload = jwt.decode(token, settings.SECRET_KEY)
            user = Account.objects.get(id=payload['user_id'])
            if not user.is_verified:
                user.is_verified = True
                user.is_active = True
                user.save()
            return Response({
                'email': 'Successfully activated'
            }, status=status.HTTP_200_OK)
        except jwt.ExpiredSignatureError as identifier:
            return Response({'error': 'Activation Expired'}, status=status.HTTP_400_BAD_REQUEST)
        except jwt.exceptions.DecodeError as identifier:
            return Response({'error': 'Invalid token'}, status=status.HTTP_400_BAD_REQUEST)


# Login Api class
class LoginAPI(GenericAPIView):
    serializer_class = LoginSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        status_response = status.HTTP_200_OK
        user_data = serializer.data
        if not user_data['two_fa_valid']:
            status_response = status.HTTP_206_PARTIAL_CONTENT

        return Response(user_data, status=status_response)


# log out current user
class LogoutAPI(APIView):
    serializer_class = LogoutSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_204_NO_CONTENT)


# sent a link to reset password.
class PasswordResetAPI(GenericAPIView):
    serializer_class = PasswordResetSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = request.data['email']
        if Account.objects.filter(email__iexact=email).exists():
            user = Account.objects.get(email=email)
            uidb64 = urlsafe_base64_encode(smart_bytes(user.id))
            token = PasswordResetTokenGenerator().make_token(user)
            current_site = get_current_site(request=request).domain
            url = reverse(
                'password_reset_confirmation', kwargs={
                    'uidb64': uidb64,
                    'token': token
                }
            )
            redirect_url = request.data.get('redirect_url', '')
            reset_link = f'{settings.FRONTEND_URL}/{url}?redirect_url={redirect_url}'
            email_template_data = {
                'protocol': request.scheme,
                'domain': current_site,
                'url': reset_link
            }
            message_body = render_to_string('email/password_reset.html', email_template_data)
            email_data = {
                'email_body': message_body,
                'to_email': user.email,
                'email_subject': 'Reset your password'
            }
            SendUserEmail.send_email(email_data)
        return Response({'success': 'Please check your Inbox, we have sent you a link to reset password.'}, status=status.HTTP_200_OK)


class PasswordConfirmationAPI(GenericAPIView):
    serializer_class = PasswordCofirmationSerializer

    def get(self, request, uidb64, token):
        redirect_url = request.GET.get('redirect_url')
        url_valid_false = f'{settings.FRONTEND_URL}?token_valid=False'
        url_front_valid_false = f'{settings.FRONTEND_URL}?token_valid=False'
        url_valid_true = f'{settings.FRONTEND_URL}?token_valid=True&message=Token Valid&uidb64={uidb64}&token={token}'
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


class SendValidationCodeAPI(APIView):
    serializer_class = EmailValidationCodeSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = request.data['email']
        if Account.objects.filter(email__iexact=email).exists():
            user = Account.objects.get(email__iexact=email)
            email_template_data = {
                'verification_code': user.verification_code,
                'user_full_name': f'{user.first_name} {user.last_name}'
            }
            message_body = render_to_string('email/verification_code.html', email_template_data)
            email_data = {
                'email_body': message_body,
                'to_email': user.email,
                'email_subject': "Verification Code"
            }
            SendUserEmail.send_email(email_data)
        return Response(serializer.data, status=status.HTTP_200_OK)


""" This view is used to confirm verification code and update database"""


class VerificationCodeConfirmAPI(APIView):
    serializer_class = VerificationCodeSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
