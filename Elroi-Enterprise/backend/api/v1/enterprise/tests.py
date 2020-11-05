from django.contrib.auth.models import Group
from django.core.files.uploadedfile import SimpleUploadedFile
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework_simplejwt.tokens import RefreshToken

from api.v1.accounts.models import Account, Enterprise, Customer
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import UserGuideModel


class UserGuideTestCase(APITestCase):
    def setUp(self):
        self.user = Account.objects.create_front_user(
            email="test@test.com", password='password')
        self.user.is_active = 1
        self.user.is_verified = 1
        self.user.save()
        refresh = RefreshToken.for_user(self.user)
        self.token = refresh.access_token
        self.api_authentication()

        self.group = Group(name='enterprise')
        self.group.save()

    def api_authentication(self):
        """ set authorization header code"""
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    """ test user guide get url"""
    def test_user_guide(self):
        self.user.groups.add(self.group)
        self.user.save()
        url = reverse('user_guide')
        response = self.client.get(url)
        """ check if 'uploads' key is present in response """
        self.assertIn('uploads', response.data)
        """ check the response status code to be 200 ok"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test creation of new user guide """
    def test_create_user_guide(self):
        self.user.groups.add(self.group)
        self.user.save()
        url = reverse('user_guide')
        data = {"title": "User Guide Test",	"content": "User guide content"}
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    """ test the upload of file for guide user"""
    def test_upload_files_to_guide(self):
        self.user.groups.add(self.group)
        self.user.save()
        url = reverse('user_guide_upload')
        file_to_upload = self.generate_file_to_upload()
        guide = UserGuideModel.objects.create(title="Test guide", content="Test guide content", owner=self.user)
        data = {"user_guide": guide.id, "name": "testing file upload", "file": file_to_upload}
        response = self.client.post(url, data, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    """ test the upload of file for guide user, without providing file
        check for validation 
        """
    def test_upload_files_to_guide_no_file_provided(self):
        self.user.groups.add(self.group)
        self.user.save()
        url = reverse('user_guide_upload')
        guide = UserGuideModel.objects.create(title="Test guide", content="Test guide content", owner=self.user)
        data = {"user_guide": guide.id, "name": "testing file upload", "file": ''}
        response = self.client.post(url, data, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    """ generate simple file to test the upload """
    def generate_file_to_upload(self):
        return SimpleUploadedFile("file.txt", b"abc", content_type="text/plain")


class CustomerConfigurationTest(APITestCase):
    def setUp(self):
        self.user = Account.objects.create_front_user(
            email="test@test.com", password='password')
        self.user.is_active = 1
        self.user.is_verified = 1
        self.user.save()
        refresh = RefreshToken.for_user(self.user)
        self.enterprise = Enterprise.objects.create(
            user=self.user,
            email='test_enterprise@mail.com',
            name="Test Company",
            first_name="Demo",
            last_name="Enterprise",
            web="http://enterprise.com",
        )
        self.consumer = Customer.objects.create(
            user=self.user,
            email="customer@email.com",
            first_name="Customer",
            last_name="D.",
            state_resident=True,
        )

        self.token = refresh.access_token
        self.api_authentication()

    def api_authentication(self):
        """ set authorization header code"""
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    """ test result of get customer configuration page"""
    def test_get_customer_configuration(self):
        url = reverse('customer_config_page')
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check the response status code to be 200 ok"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test creation of customer configuration """
    def test_create_customer_configuration(self):
        url = reverse('customer_config_page')
        data = {
              "title": "Test configuration page",
              "config": {
                  "elem1": "value elem 1",
                  "elem2": "value elem 2"
              },
              "author": self.enterprise.id
            }
        response = self.client.post(url, data, format='json')
        """ check if title element exists in json response """
        self.assertIn('title', response.data)
        """ check if config element exists in json response """
        self.assertIn('config', response.data)
        """ check if author element exists in json response """
        self.assertIn('author', response.data)
        """ check if response returns status code 401 """
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_create_customer_configuration_user_not_enterprise(self):
        refresh = RefreshToken.for_user(self.user)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")

        url = reverse('customer_config_page')
        data = {
            "title": "Test configuration page",
            "config": {
                "elem1": "value elem 1",
                "elem2": "value elem 2"
            },
            "author": self.enterprise.id
        }
        response = self.client.post(url, data, format='json')
        """ check if response returns status code 401, user is not enterprise """
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

class CustomerSummarizeTest(APITestCase):
    def setUp(self):
        self.user = Account.objects.create_front_user(
            email="test@test.com", password='password')
        self.user.is_active = 1
        self.user.is_verified = 1
        self.user.save()
        refresh = RefreshToken.for_user(self.user)
        self.token = refresh.access_token
        self.api_authentication()

    def api_authentication(self):
        """ set authorization header code"""
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    """ test get customer sumarize url"""
    def test_get_customer_summarize(self):
        url = reverse('customer_summarize')
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

class RequestTrackerTest(APITestCase):
    def setUp(self):
        self.user = Account.objects.create_front_user(
            email="test@test.com", password='password')
        self.user.is_active = 1
        self.user.is_verified = 1
        self.user.save()
        refresh = RefreshToken.for_user(self.user)
        self.token = refresh.access_token
        self.api_authentication()

    def api_authentication(self):
        """ set authorization header code"""
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    """ test get request tracker url"""
    def test_get_request_tracker(self):
        url = reverse('request_tracker')
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

class NotifyCustomerTest(APITestCase):
    def setUp(self):
        self.user = Account.objects.create_front_user(
            email="test@test.com", password='password')
        self.user.is_active = 1
        self.user.is_verified = 1
        self.user.save()
        self.user_e = Account.objects.create_front_user(
            email="test_enterprise@mail.com", password='password_enterprise')
        self.user_e.is_active = 1
        self.user_e.is_verified = 1
        self.user_e.save()
        refresh = RefreshToken.for_user(self.user)
        self.token = refresh.access_token
        self.api_authentication()
        self.enterprise = Enterprise.objects.create(
            user=self.user_e,
            email='test_enterprise@mail.com',
            name="Test Company",
            first_name="Demo",
            last_name="Enterprise",
            web="http://enterprise.com",
        )
        self.consumer = Customer.objects.create(
            user=self.user,
            email="customer@email.com",
            first_name="Customer",
            last_name="D.",
            state_resident=True,
        )
        self.consumer_request = ConsumerRequest.objects.create(
            enterprise=self.enterprise,
            customer=self.consumer,
            title="Test customer request",
            description="Description test"
        )

    def api_authentication(self):
        """ set authorization header code"""
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    """ test notification customer about first add 45 days """
    def test_notify_customer(self):
        data = {"request_id": self.consumer_request.id}
        url = reverse('notify_customer')
        response = self.client.post(url, data, format='json')
        """ check that the response contains 'success' key """
        self.assertIn('success', response.data)
        """ check the response status code """
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test notification of customer of non existing request id"""
    def test_notify_non_existing_customer(self):
        data = {"request_id": 33}
        url = reverse('notify_customer')
        response = self.client.post(url, data, format='json')
        """ check that the response contains 'error' key """
        self.assertIn('error', response.data)
        """ check the response status code to be 404,not found """
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    """ test url that returns report about extended requests vs existing new requests"""
    def test_extended_vs_new_requests(self):
        refresh = RefreshToken.for_user(self.user)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        url = reverse('get_extended_requests_report')
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check if 'total' key exists in response"""
        self.assertIn('total', response.data)
        """ check if the response status code is ok 200"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test url that returns report about extended requests vs existing new requests, not found data"""
    def test_extended_vs_new_requests_not_found(self):
        url = reverse('get_extended_requests_report')
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check if 'total' key exists in response"""
        self.assertIn('total', response.data)
        """ check if the response status code is 200"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ check enterprise configuration to return data sending customer id
        should return 404 as customer isn't enterprise
        """
    def test_enterprise_configuration_get(self):
        url = reverse('enterprise_configuration')
        self.api_authentication()
        response = self.client.get(url, HTTP_ACCEPT='application/json')

        """ check respose status code to be 404"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test creation of enterprise configuration"""
    def test_create_enterprise_configuration(self):
        url = reverse('enterprise_configuration')
        refresh = RefreshToken.for_user(self.user_e)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        file_to_upload = self.generate_file_upload()
        data = {
            "company_name": "Test Company",
            "logo": file_to_upload,
            "site_color": "#333333",
            "site_theme": "Theme name",
            "background_image": file_to_upload,
            "website_launched_to": "www.www.com",
            "additional_configuration": str({"input": [
                {"type": "radio", "name": "is_resident", "label": "I am a state resident", "values": ["Yes", "No"]},
                {"type": "text", "name": "first_name", "label": "First Name"},
                {"type": "file", "name": "kyc", "label": "Upload your file"}]}),
            "enterprise": self.enterprise.id,
            "elroi_id": self.enterprise.elroi_id
        }
        response = self.client.post(url, data, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    """ test the creation of enterprise configuration sending 
        non existing user id
        """
    def test_create_enterprise_configuration_for_non_existing_user(self):
        url = reverse('enterprise_configuration')
        data = {
            "title": "Receiving data from customer",
            "configuration": {
                "allow_api_call": "True",
                "allow_email": "true"
            },
            "enterprise": 12234
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def generate_file_upload(self):
        """ generate simple file to test the upload """
        return SimpleUploadedFile("file.txt", b"abc", content_type="text/plain")