from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView, TokenObtainPairView

from .views import (
    LoginAPI, VerifyEmailAPI, LogoutAPI,
    PasswordResetAPI, PasswordConfirmationAPI, SendValidationCodeAPI, VerificationCodeConfirmAPI, RegisterCustomer,
    RegisterEnterprise, AssessmentSharedLink, AccountProfileSettings
)

urlpatterns = [
    path('register/customer/<elroi_id>', RegisterCustomer.as_view(), name="register_customer"),
    path('register/enterprise/', RegisterEnterprise.as_view(), name="register_enterprise"),
    path('profile-settings/', AccountProfileSettings.as_view(), name="profile_settings"),
    path('login/', LoginAPI.as_view(), name="login_api"),
    path('logout/', LogoutAPI.as_view(), name="logout_api"),
    path('email-verify/', VerifyEmailAPI.as_view(), name='email_verify'),
    path('password-reset/', PasswordResetAPI.as_view(), name='password_reset'),
    path('password-confirmation/<uidb64>/<token>', PasswordConfirmationAPI.as_view(),
         name='password_reset_confirmation'),
    path('view-assessment/<token>', AssessmentSharedLink.as_view(), name='view_shared_assessment'),
    path('verification-code', SendValidationCodeAPI.as_view(), name='verification_code'),
    path('validate-verification-code', VerificationCodeConfirmAPI.as_view(), name='validate_verification_code'),

    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh')
]
