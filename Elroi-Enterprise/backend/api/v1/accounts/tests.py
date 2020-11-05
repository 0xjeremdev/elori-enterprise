import json

from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.core.files.uploadedfile import SimpleUploadedFile
from django.urls import reverse
from django.utils.encoding import smart_bytes
from django.utils.http import urlsafe_base64_encode
from rest_framework.authtoken.models import Token
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.test import APITestCase
from rest_framework import status

from api.v1.accounts.models import Account, Enterprise
from api.v1.enterprise.models import EnterpriseConfigurationModel


class AccountsTest(APITestCase):

    def setUp(self):
        """ create customer user from start """
        self.user_customer = Account.objects.create_front_user(
            email="customer@email.com", password="password_customer"
        )
        self.user_enterprise = Account.objects.create_front_user(
            email="test_enterprise@mail.com", password="password_secret"
        )
        self.user_enterprise.is_active = True
        self.user_enterprise.is_verified = True
        self.user_enterprise.is_superuser = True
        self.user_enterprise.save()
        """ generate token used to authorize requests """
        refresh = RefreshToken.for_user(self.user_customer)
        self.token = refresh.access_token
        self.default_enterprise = Enterprise.objects.create(
            user=self.user_enterprise,
            email='test_enterprise@mail.com',
            name="Test Company",
            first_name="Demo",
            last_name="Enterprise",
            web="http://enterprise.com",
        )
        logo_upload = self.generate_file_upload()
        additional_config = {"input": [
            {"type": "radio", "name": "is_resident", "label": "I am a state resident", "values": ["Yes", "No"]},
            {"type": "text", "name": "first_name", "label": "First Name"},
            {"type": "text", "name": "last_name", "label": "Last Name"},
            {"type": "file", "name": "kyc", "label": "Upload your file"}]}
        EnterpriseConfigurationModel.objects.create(
            company_name="Test Company Request Form",
            logo=logo_upload,
            site_color="#ffffff",
            site_theme="Test Theme",
            background_image=logo_upload,
            website_launched_to="www.www.com",
            additional_configuration=additional_config,
            enterprise_id=self.default_enterprise
        )

        self.post_data_customer = {
            "is_resident": True,
            "first_name": "Customer",
            "last_name": "Test",
            "email": "customer@email.com",
            "password": "password_customer",
            "kyc": logo_upload
        }

        self.post_data_enterprise = {
            "name": "Enterprise",
            "email": "enterprise@email.com",
            "first_name": "Demo",
            "last_name": "D.",
            "web": "http://google.com",
            "password": "password_enterprise"
        }


        """ list of urls used for tests """
        self.register_customer = reverse('register_customer', kwargs={"elroi_id":self.default_enterprise.elroi_id})
        self.register_enterprise = reverse('register_enterprise')
        self.login_url = reverse('login_api')

    def generate_file_upload(self):
        """ generate simple file to test the upload """
        return SimpleUploadedFile("file.txt", b"abc", content_type="text/plain")

    def api_authentication(self):
        """ set authorization header code"""
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    def test_create_customer_user(self):
        """ send the post request to register url to create customer profile and get the response """
        response = self.client.post(self.register_customer, self.post_data_customer, format='multipart')
        """Response code is 201 that means account was created"""
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        """make sure that elroi_id is returned in response"""
        self.assertTrue('elroi_id' in response.data)

        """elroi_id is not none in response"""
        self.assertIsNotNone('elroi_id' in response.data)

        """ check if elroi_id length is 8 characters """
        self.assertEqual(len(response.data['elroi_id']), 8)

        """make sure that password is not returned in json response"""
        self.assertFalse('password' in response.data)

    def test_create_enterprise_user(self):
        """ make the request to register url to create enterprise profile and get response """
        response = self.client.post(self.register_enterprise, self.post_data_enterprise, format='json')

        """Response code is 201 that means account was created"""
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        """make sure that elroi_id is returned in response"""
        self.assertTrue('elroi_id' in response.data['user'])

        """elroi_id is not none in response"""
        self.assertIsNotNone('elroi_id' in response.data['user'])

        """check if elroi_id is prefixed with 'E-' """
        self.assertIn('E-', response.data['user']['elroi_id'])

        """ check if elroi_id length is 8 characters """
        self.assertEqual(len(response.data['user']['elroi_id']), 8)

        """make sure that password is not returned in json response"""
        self.assertFalse('password' in response.data['user'])

    def test_create_account_with_short_password(self):
        """ testing creation of account validation password size"""
        data = {
            "state_resident": True,
            "first_name": "Customer",
            "last_name": "Test",
            "email": "customer@email.com",
            "password": "123456",
        }
        """ send data and getting response from register url with wrong password size"""
        response = self.client.post(self.register_customer, data, format='json')

        """ check if the response code is 400 as expecting in case of short password"""
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_create_account_without_password(self):
        """ testing registration with empty password """
        data = {
            "state_resident": True,
            "first_name": "Customer",
            "last_name": "Test",
            "email": "customer@email.com",
            "password": "",
        }
        """ send data and getting response from register url with empty password"""
        response = self.client.post(self.register_customer, data, format='json')
        """ check if the response code is 400 as expecting in case of empty password"""
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_create_account_without_email(self):
        """ testing registration with no email provided """
        data = {
            "state_resident": True,
            "first_name": "Customer",
            "last_name": "Test",
            "email": "",
            "password": "password_secret",
        }
        """ send data and receive response from register url with no email provided """
        response = self.client.post(self.register_customer, data, format='json')
        """ check returned response to be 400 as expected in case of no email provided """
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_create_account_existing_email(self):
        """ testing registration with already registered email """
        data = {
            "state_resident": True,
            "first_name": "Test",
            "last_name": "user",
            "email": "test@user.com",
            "password": "password",
        }
        """ send data and receive response from register url with already registered email"""
        response = self.client.post(self.register_customer, data, format='json')
        """ check returned status code 400 as provided in case of validation existing email"""
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_create_account_with_invalid_email(self):
        """ test creation of account with invalid email"""
        data = {
            "state_resident": True,
            "first_name": "Customer",
            "last_name": "Test",
            "email": "emailaddress",
            "password": "password_secret",
        }
        """ send data and receive response from registration"""
        response = self.client.post(self.register_customer, data, format='json')
        """ check returned status and compare with 400 as shoujld be in case of invalid email"""
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_login_email_unverified(self):
        """ test account login with unverified email """
        user = Account.objects.create_front_user(email='test@user.com', password="123456789")

        data = {
            "email": user.email,
            "password": "123456789"
        }
        """ send and receive result from login url """
        response = self.client.post(self.login_url, data, format='json')
        """ in case of failed login returned code should be 401"""
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_login_otp_unverified(self):
        """ test login when verification code wasn't inserted """
        user = Account.objects.create_front_user(email='test2@user.com', password="123456789")
        user.is_active = True
        user.is_verified = True
        user.verification_code = None
        user.otp_verified = False
        user.save()
        data = {
            "email": user.email,
            "password": "123456789"
        }
        """ send data and receive result from login page """
        response = self.client.post(self.login_url, data, format='json')
        """ in case of unverified otp code, returned status code should be 206 """
        self.assertEqual(response.status_code, status.HTTP_206_PARTIAL_CONTENT)

    def test_login_valid(self):
        """ testing login action for verified account """
        user = Account.objects.create_front_user(email='test1@user.com', password="123456789")
        user.is_active = True
        user.is_verified = True
        user.verification_code = '123456'
        user.otp_verified = True
        user.save()
        data = {
            "email": user.email,
            "password": "123456789"
        }
        """ send data and receive results from login page"""
        response = self.client.post(self.login_url, data, format='json')
        """ check if returned status code is 200, that means login successful """
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test email verify by token, after registration"""
    def test_email_verify(self):
        email_url = reverse('email_verify')
        url = f'{email_url}?token={self.token}'
        self.api_authentication()
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test password reset functionality """
    def test_password_reset(self):
        url = reverse('password_reset')
        data = {
            "email": self.user_customer.email
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ check the view SendValidationCodeAPI, sending verification code
        on login to activate 2FA, the code is sent"""
    def test_verification_code(self):
        url = reverse('verification_code')
        data = {"email": self.user_customer.email}
        self.api_authentication()
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test the confirmation of the code used for activation 2FA
        VerificationCodeConfirmAPI
    """
    def test_verification_code_confirm(self):
        url = reverse('validate_verification_code')
        user = Account.objects.create_front_user(email='test2@user.com', password="123456789")
        user.is_active = True
        user.is_verified = True
        user.verification_code = 123456
        user.otp_verified = False
        user.save()
        user_auth = authenticate(email=user.email, password="123456789")
        token = RefreshToken.for_user(user_auth).access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        data = {"verification_code": user.verification_code}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

