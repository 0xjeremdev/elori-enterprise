import json
from django.contrib.auth.models import User, Group
from django.urls import reverse
from rest_framework.authtoken.models import Token
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.test import APITestCase
from rest_framework import status

from api.v1.accounts.models import Account
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import UserGuide
from api.v1.enterprise.serializers import UserGuideSerializer

class UserGuideTestCase(APITestCase):
    def setUp(self):
        self.user = Account.objects.create_front_user(
            state_resident=True,
            first_name="Test",
            last_name="Last", email="test@test.com", password='password', account_type=1)
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

    """ test user guide url"""
    def test_user_guide(self):
        self.user.groups.add(self.group)
        self.user.save()
        url = reverse('user_guide')
        response = self.client.get(url)
        """ check the response status code to be 200 ok"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

class CustomerConfigurationTest(APITestCase):
    def setUp(self):
        self.user = Account.objects.create_front_user(
            state_resident=True,
            first_name="Test",
            last_name="Last", email="test@test.com", password='password', account_type=1)
        self.user.is_active = 1
        self.user.is_verified = 1
        self.user.save()
        refresh = RefreshToken.for_user(self.user)
        self.customer = Account.objects.create_front_user(
            state_resident=True,
            first_name="Test",
            last_name="Last", email="test2@test.com", password='password', account_type=0)
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
    def test_create_customr_configuration(self):
        url = reverse('customer_config_page')
        data = {
              "title": "Test configuration page",
              "config": {
                  "elem1": "value elem 1",
                  "elem2": "value elem 2"
              },
              "author": self.user.id
            }
        response = self.client.post(url, data, format='json')
        """ check if title element exists in json response """
        self.assertIn('title', response.data)
        """ check if config element exists in json response """
        self.assertIn('config', response.data)
        """ check if author element exists in json response """
        self.assertIn('author', response.data)
        """ check if response returns status code 201, configuration was created """
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_create_customer_configuration_user_not_enterprise(self):
        refresh = RefreshToken.for_user(self.customer)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")

        url = reverse('customer_config_page')
        data = {
            "title": "Test configuration page",
            "config": {
                "elem1": "value elem 1",
                "elem2": "value elem 2"
            },
            "author": self.customer.id
        }
        response = self.client.post(url, data, format='json')
        """ check if response returns status code 401, user is not enterprise """
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

class CustomerSummarizeTest(APITestCase):
    def setUp(self):
        self.user = Account.objects.create_front_user(
            state_resident=True,
            first_name="Test",
            last_name="Last", email="test@test.com", password='password', account_type=0)
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
            state_resident=True,
            first_name="Test",
            last_name="Last", email="test@test.com", password='password', account_type=0)
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
            state_resident=True,
            first_name="Test",
            last_name="Last", email="test@test.com", password='password', account_type=0)
        self.user.is_active = 1
        self.user.is_verified = 1
        self.user.save()
        refresh = RefreshToken.for_user(self.user)
        self.token = refresh.access_token
        self.api_authentication()
        self.enterprise = Account.objects.create_front_user(
            state_resident=True,
            first_name="Test",
            last_name="Last",
            email="test_e@test.com",
            password='password',
            account_type=1)
        self.consumer_request = ConsumerRequest.objects.create(
            enterprise=self.enterprise,
            customer=self.user,
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
        refresh = RefreshToken.for_user(self.enterprise)
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
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check for error key in response """
        self.assertIn('error', response.data)
        """ check respose status code to be 404"""
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    """ test creation of enterprise configuration"""
    def test_create_enterprise_configuration(self):
        url = reverse('enterprise_configuration')
        refresh = RefreshToken.for_user(self.enterprise)
        token = refresh.access_token
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(token)}")
        data = {
            "title": "Receiving data from customer",
            "configuration": {
                "allow_api_call": "True",
                "allow_email": "true"
            },
            "enterprise": self.enterprise.id
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

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
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)