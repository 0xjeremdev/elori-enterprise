from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView, TokenObtainPairView

from .views import (
    RegisterAPI, LoginAPI, VerifyEmailAPI, LogoutAPI,
    PasswordResetAPI, PasswordConfirmationAPI, SendValidationCodeAPI, VerificationCodeConfirmAPI
)

urlpatterns = [
    path('register/', RegisterAPI.as_view(), name="register_api"),
    path('login/', LoginAPI.as_view(), name="login_api"),
    path('logout/', LogoutAPI.as_view(), name="logout_api"),
    path('email-verify/', VerifyEmailAPI.as_view(), name='email_verify'),
    path('password-reset/', PasswordResetAPI.as_view(), name='password_reset'),
    path('password-confirmation/<uidb64>/<token>', PasswordConfirmationAPI.as_view(),
         name='password_reset_confirmation'),
    path('verification-code', SendValidationCodeAPI.as_view(), name='verification_code'),
    path('validate-verification-code', VerificationCodeConfirmAPI.as_view(), name='validate_verification_code'),

    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh')
]
