import json
from datetime import timedelta, date

from django.contrib.auth import authenticate
from django.contrib.auth.models import User, Group
from django.core.files.uploadedfile import SimpleUploadedFile
from django.urls import reverse
from rest_framework.authtoken.models import Token
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.test import APITestCase
from rest_framework import status

from api.v1.accounts.models import Account, Enterprise


class ElroiAdminTest(APITestCase):

    def setUp(self):
        self.email = "enterprise@email.com"
        self.password = "enterprise_password"
        self.user = Account.objects.create_front_user(
            email=self.email, password=self.password)
        self.user.is_active = True
        self.user.is_verified = True
        self.user.is_superuser = True
        self.user.is_staff = True
        self.user.save()
        self.enterprise = Enterprise.objects.create(
            user=self.user,
            email=self.email,
            name="Test Company",
            first_name="Demo",
            last_name="Enterprise",
            web="http://enterprise.com",
        )
        refresh = RefreshToken.for_user(self.user)
        self.token = refresh.access_token

    def api_authentication(self):
        """ set authorization header code"""
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    def test_activity_log_anonymous_user(self):
        """ test access to activity log for anonymous users"""
        url = reverse('admin_activity_log')
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check if the response returns unauthorized code"""
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_activity_log_authorized_user(self):
        user = authenticate(email=self.email, password=self.password)
        token = RefreshToken.for_user(user).access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        url = reverse('admin_activity_log')
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_enterprise_list(self):
        url = reverse('admin_enterprise')
        user = authenticate(email=self.email, password=self.password)
        refresh = RefreshToken.for_user(user)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_enterprise_customers(self):
        url = reverse('admin_enterprise_customers')
        user = authenticate(email=self.email, password=self.password)
        refresh = RefreshToken.for_user(user)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_enterprise_maintenance(self):
        url = reverse('admin_enterprise_maintenance')
        user = authenticate(email=self.email, password=self.password)
        refresh = RefreshToken.for_user(user)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        end_date = date.today() + timedelta(days=10)

        data = {
            "elroi_id": self.enterprise.elroi_id,
            "is_active": False,
            "turn_off_date": end_date.strftime('%Y-%m-%d %H:%M:%S')
        }
        response = self.client.put(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_get_enterprise_trial_config(self):
        url = reverse('admin_enterprise_trial_config')
        user = authenticate(email=self.email, password=self.password)
        refresh = RefreshToken.for_user(user)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_post_enterprise_trial_config(self):
        url = reverse('admin_enterprise_trial_config')
        user = authenticate(email=self.email, password=self.password)
        refresh = RefreshToken.for_user(user)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        data = {
            "name": "trial config test",
            "key": "key test",
            "value": "value test"
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_user_guide_upload(self):
        url = reverse('admin_upload_user_guide')
        user = authenticate(email=self.email, password=self.password)
        refresh = RefreshToken.for_user(user)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        file_to_upload = SimpleUploadedFile("file.txt", b"abc", content_type="text/plain")
        data = {
            "enterprise": self.enterprise,
            "title": "test",
            "content": "test content",
            "file": file_to_upload
        }
        response = self.client.post(url, data, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_get_user_guide_uploaded(self):
        url = reverse('admin_upload_user_guide')
        user = authenticate(email=self.email, password=self.password)
        refresh = RefreshToken.for_user(user)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
