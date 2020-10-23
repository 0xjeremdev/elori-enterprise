import json
from django.contrib.auth.models import User
from django.urls import reverse
from rest_framework.authtoken.models import Token
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.test import APITestCase
from rest_framework import status

from api.v1.accounts.models import Account


class ConsumerRequestsTest(APITestCase):
    def setUp(self):
        """ create an account for tests """
        self.user = Account.objects.create_front_user(
            state_resident=True,
            first_name="Test",
            last_name="Last",
            email="test@test.com",
            password='password',
            account_type=0)
        self.user.is_active = True
        self.user.is_verified = True
        self.user.save()
        refresh = RefreshToken.for_user(self.user)
        self.enterprise_user = Account.objects.create_front_user(
            state_resident=True,
            first_name="Test",
            last_name="Enterprise",
            email="enterprise@email.com",
            password="secret",
            account_type=1
        )

        self.token = refresh.access_token
        self.api_authentication()

    """ set the Authorization header """
    def api_authentication(self):
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    """" test the customer request route without parameters"""
    def test_get_customer_request(self):
        url = reverse('consumer_request')
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check if the response status code is 200"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test get customers requests by day"""
    def test_get_customer_request_period_day(self):
        url = reverse('consumer_request')
        response = self.client.get(url, {'period': 'day'}, HTTP_ACCEPT='application/json')
        """ check if the response status code is 200"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test get customers requests by week """
    def test_get_customer_request_period_week(self):
        url = reverse('consumer_request')
        response = self.client.get(url, {'period': 'week'}, HTTP_ACCEPT='application/json')
        """ check if the response status code is 200"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test get customer request by month """
    def test_get_customer_request_period_month(self):
        url = reverse('consumer_request')
        response = self.client.get(url, {'period': 'month'}, HTTP_ACCEPT='application/json')
        """ check if the response status code is 200"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test get customer requests by year"""
    def test_get_customer_request_period_year(self):
        url = reverse('consumer_request')
        response = self.client.get(url, {'period': 'year'}, HTTP_ACCEPT='application/json')
        """ check if the response status code is 200, response contains good results"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ test creation of customer request successfully """
    def test_create_customer_request(self):
        data = {
            "title": "Test customer request",
            "request_type": 1,
            "description": "Test customer request description",
            "is_data_subject_name": True,
            "status": 0,
            "extend_requested": False,
            "customer": self.user.id,
            "enterprise": self.enterprise_user.id
        }
        url = reverse('consumer_request')
        response = self.client.post(url, data, format='json')
        """ check if response contins elroi_id, means that customer request was created and return good values."""
        self.assertIn('elroi_id', response.data)
        """ check if the response status code is 201, customer request was created"""
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    """ test creation of customer request without specified enterprise id"""
    def test_create_customer_request_no_enterprise(self):
        data = {
            "title": "Test customer request",
            "request_type": 1,
            "description": "Test customer request description",
            "is_data_subject_name": True,
            "status": 0,
            "extend_requested": False,
            "customer": self.user.id
        }
        url = reverse('consumer_request')
        response = self.client.post(url, data, format='json')
        """ check if the response status code is 400"""
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    """ test creation of customer request without specified customer id"""
    def test_create_customer_request_no_customer_id(self):
        data = {
            "title": "Test customer request",
            "request_type": 1,
            "description": "Test customer request description",
            "is_data_subject_name": True,
            "status": 0,
            "extend_requested": False,
            "enterprise": self.enterprise_user.id
        }
        url = reverse('consumer_request')
        response = self.client.post(url, data, format='json')
        """ check if the response status code is 400"""
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class ConsumerRequestProgressTest(APITestCase):
    def setUp(self):
        """ create an account for tests """
        self.user = Account.objects.create_front_user(
            state_resident=True,
            first_name="Test",
            last_name="Last",
            email="test@test.com",
            password='password',
            account_type=0)
        self.user.is_active = True
        self.user.is_verified = True
        self.user.save()
        refresh = RefreshToken.for_user(self.user)
        self.token = refresh.access_token
        self.api_authentication()

    """ set the Authorization header """
    def api_authentication(self):
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    """ testing get progress of customer request by week"""
    def test_consumer_request_progress_period_week(self):
        url = reverse('consumer_request_progress', args=['week'])
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check if 'active' element is present in response json"""
        self.assertIn('active', response.data)
        """ check if 'approved' element is present in response json"""
        self.assertIn('approved', response.data)
        """ check if 'rejected' element is present in response json"""
        self.assertIn('rejected', response.data)
        """ check if response status is 200 ok"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ testing get progress of customer request by year"""
    def test_consumer_request_progress_period_year(self):
        url = reverse('consumer_request_progress', args=['year'])
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check if 'active' element is present in response json"""
        self.assertIn('active', response.data)
        """ check if 'approved' element is present in response json"""
        self.assertIn('approved', response.data)
        """ check if 'rejected' element is present in response json"""
        self.assertIn('rejected', response.data)
        """ check if response status is 200 ok"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    """ testing get progress of customer request by month"""
    def test_consumer_request_progress_period_month(self):
        url = reverse('consumer_request_progress', args=['month'])
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check if 'active' element is present in response json"""
        self.assertIn('active', response.data)
        """ check if 'approved' element is present in response json"""
        self.assertIn('approved', response.data)
        """ check if 'rejected' element is present in response json"""
        self.assertIn('rejected', response.data)
        """ check if response status is 200 ok"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class CustomerRequestMadeTest(APITestCase):
    def setUp(self):
        """ create an account for tests """
        self.user = Account.objects.create_front_user(
            state_resident=True,
            first_name="Test",
            last_name="Last",
            email="test@test.com",
            password='password',
            account_type=0)
        self.user.is_active = True
        self.user.is_verified = True
        self.user.save()
        refresh = RefreshToken.for_user(self.user)
        self.token = refresh.access_token
        self.api_authentication()

    """ set the Authorization header """
    def api_authentication(self):
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {str(self.token)}")

    """ test the request to customer requests made"""
    def get_customer_request_made_statistic(self):
        url = reverse('consumer_request_made_confirmed')
        response = self.client.get(url, HTTP_ACCEPT='application/json')
        """ check if response contains confirmed element """
        self.assertIn('confirmed', response.data)
        """ check if response contains total_made element """
        self.assertIn('total_made', response.data)
        """ check if response contains last_date element """
        self.assertIn('last_date', response.data)
        """ check if response status is ok"""
        self.assertEqual(response.status_code, status.HTTP_200_OK)
