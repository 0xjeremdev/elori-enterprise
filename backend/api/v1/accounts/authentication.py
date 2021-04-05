from rest_framework.authentication import BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed
from django.conf import settings


class CustomAuthentication(BaseAuthentication):
    def authenticate(self, request, **kwargs):
        auth_header_value = request.META.get("HTTP_ELROIAUTHTOKEN", "")
        print(auth_header_value)
        if auth_header_value != settings.ELROI_TOKEN:
            raise AuthenticationFailed('Invalid Elroi Auth Token.')
