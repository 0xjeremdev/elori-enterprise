from typing import re

from django.template.loader import render_to_string
from rest_framework import mixins, permissions, status
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from rest_framework.views import APIView

from api.v1.accounts.permissions import HasEnterpriseViewPermission
from api.v1.accounts.utlis import SendUserEmail
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import UserGuide, CustomerConfiguration, EnterpriseConfigurationModel
from api.v1.enterprise.serializers import UserGuideSerializer, CustomerConfigurationSerializer, \
    CustomerSummarizeSerializer, RequestTrackerSerializer, EnterpriseConfigurationSerializer


class UserGuide(mixins.ListModelMixin, GenericAPIView):
    queryset = UserGuide.objects.all()
    serializer_class = UserGuideSerializer
    permission_classes = (permissions.IsAuthenticated, HasEnterpriseViewPermission)

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)


class CustomerConfiguration(mixins.ListModelMixin,
                            mixins.CreateModelMixin,
                            mixins.UpdateModelMixin,
                            mixins.DestroyModelMixin,
                            GenericAPIView):
    queryset = CustomerConfiguration.objects.all()
    serializer_class = CustomerConfigurationSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    # create new configuration
    def post(self, request, *args, **kwargs):
        if request.user and request.user.account_type == 1:
            return self.create(request, *args, **kwargs)
        return Response({
            'error': 'You are not allowed to continue',
        }, status=status.HTTP_401_UNAUTHORIZED)

    # update configuration
    def put(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)

    # delete configuration
    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)


class CustomerSummarize(mixins.ListModelMixin, GenericAPIView):
    queryset = ConsumerRequest.objects.all()
    serializer_class = CustomerSummarizeSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        if request.GET.get('id'):
            self.queryset = ConsumerRequest.objects.filter(id=request.GET.get('id'))
        return self.list(request, *args, **kwargs)


class RequestTracker(mixins.ListModelMixin, GenericAPIView):
    queryset = ConsumerRequest.objects.all()
    serializer_class = RequestTrackerSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        if request.GET.get('id'):
            self.queryset = ConsumerRequest.objects.filter(elroi_id=request.GET.get('id'))
        return self.list(request, *args, **kwargs)


class NotifyCustomer(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request, *args, **kwargs):
        request_id = request.data.get('request_id')
        try:
            db_res = ConsumerRequest.objects.get(id=request_id)
            customer_email = db_res.customer.email
            user_full_name = db_res.customer.full_name()
            email_template_data = {
                'user_full_name': user_full_name
            }
            message_body = render_to_string('email/first_45_days_period.html', email_template_data)
            email_data = {
                'email_body': message_body,
                'to_email': customer_email,
                'email_subject': "First add 45 days"
            }
            SendUserEmail.send_email(email_data)
            return Response({
                "success": True,
                "message": "Email was sent."
            }, status=status.HTTP_200_OK)
        except ConsumerRequest.DoesNotExist:
            return Response({'error': 'Invalid customer'}, status=status.HTTP_404_NOT_FOUND)


class ExtendedVsNewRequests(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        user_id = request.user.id
        try:
            enterprise_db = ConsumerRequest.objects.filter(enterprise__id=user_id, enterprise__account_type=1)
            if enterprise_db.exists():
                total_requsts = enterprise_db.count()
                extended = enterprise_db.filter(extend_requested=1).count()
                new_requests = enterprise_db.filter(extend_requested=0).count()
                extended_percent = round((extended * 100) / total_requsts, 2)
                new_percent = round(100 - extended_percent)
                return Response({
                    "total": total_requsts,
                    "extended": extended,
                    "new": new_requests,
                    "percentage": {
                        "extended": f'{extended_percent}%',
                        "new": f'{new_percent}%'
                    }
                }, status=status.HTTP_200_OK)
            else:
                return Response({
                    "total": 0,
                    "extended": 0,
                    "new": 0,
                    "percentage": {
                        "extended": '0%',
                        "new": '0%'
                    }
                }, status=status.HTTP_200_OK)
        except ConsumerRequest.DoesNotExist:
            return Response({"error": "Data not found."}, status=status.HTTP_404_NOT_FOUND)


class EnterpriseConfiguration(
                            mixins.ListModelMixin,
                            mixins.CreateModelMixin,
                            mixins.UpdateModelMixin,
                            mixins.DestroyModelMixin,
                            GenericAPIView,):
    serializer_class = EnterpriseConfigurationSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        try:
            self.queryset = EnterpriseConfigurationModel.objects.get(enterprise__id=request.user.id)
            return self.list(request, *args, **kwargs)
        except EnterpriseConfigurationModel.DoesNotExist:
            return Response({"error": "Page not found"}, status=status.HTTP_404_NOT_FOUND)

    # create new configuration
    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)
        if request.user and request.user.account_type == 1:
            return self.create(request, *args, **kwargs)
        return Response({
            'error': 'You are not allowed to continue',
        }, status=status.HTTP_401_UNAUTHORIZED)

    # update configuration
    def put(self, request, *args, **kwargs):
        self.queryset = EnterpriseConfigurationModel.objects.get(enterprise__id=request.user.id, id=request.data.id)
        return self.update(request, *args, **kwargs)

    # delete configuration
    def delete(self, request, *args, **kwargs):
        self.queryset = EnterpriseConfigurationModel.objects.get(enterprise__id=request.user.id, id=request.data.id)
        return self.destroy(request, *args, **kwargs)


""" method to validate email address """


def validate_email_format(email):
    regex = '^[a-z0-9]+[\._]?[a-z0-9]+[@]\w+[.]\w{2,3}$'
    if re.search(regex, email):
        return True
    return False
