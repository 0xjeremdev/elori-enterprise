from django.db import IntegrityError
from rest_framework import mixins
from rest_framework import status, permissions
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response

from api.v1.accounts.models import Enterprise, Customer
from api.v1.analytics.models import ActivityLog
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.elroi_admin.models import AdminEnterpriseConfig
from api.v1.elroi_admin.serializers import EnterpriseTrialSerializer, EnterpriseMaintenanceSerializer, \
    EnterprisePaymentSerializer, EnterpriseCustomersSerializer, EnterpriseActivitySerializer


class EnterpriseTrialConfigApi(mixins.ListModelMixin, mixins.UpdateModelMixin, GenericAPIView):
    serializer_class = EnterpriseTrialSerializer
    permission_classes = (permissions.IsAdminUser,)
    queryset = AdminEnterpriseConfig.objects.all()
    """
    Configuration for trial packages for enterprise
    - set up the number of days for trial period
    """

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        data = request.data.copy()
        data['created_by'] = request.user.id
        data['updated_by'] = request.user.id
        serializer = self.serializer_class(data=data)
        if serializer.is_valid():
            serializer.save(created_by=request.user, updated_by=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def update(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)


class EnterpriseMaintenanceApi(mixins.UpdateModelMixin, GenericAPIView):
    serializer_class = EnterpriseMaintenanceSerializer
    permission_classes = (permissions.IsAdminUser,)
    queryset = Enterprise.objects.all()
    """ Used to manage the status of the enterprise
        - put the enterprise profile offline
        """

    def put(self, request, *args, **kwargs):
        try:
            self.queryset = Enterprise.objects.filter(
                elroi_id__exact=request.data.get('elroi_id'),
                user__id=request.user.id)
            data = request.data.copy()
            data['updated_by'] = request.user.id
            serializer = self.serializer_class(data=data)
            if serializer.is_valid():
                try:
                    Enterprise.objects.filter(
                        elroi_id__exact=data.get('elroi_id'),
                        user__id=request.user.id
                    ).update(is_active=data.get('is_active'), turn_off_date=data.get('turn_off_date'))

                    enterprise = self.queryset.get(elroi_id__exact=data.get('elroi_id'))
                    return Response({
                        'elroi_id': enterprise.elroi_id,
                        'trial_start': enterprise.trial_start,
                        'trial_end': enterprise.trial_end,
                        'is_active': enterprise.is_active,
                        'updated_by': enterprise.user_id
                    }, status=status.HTTP_200_OK)
                except IntegrityError:
                    return Response({"error": "You can't update the elroi_id value"},
                                    status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Enterprise.DoesNotExist:
            return Response({"error": "Enterprise was not found, or you are not allowed to continue"},
                            status=status.HTTP_401_UNAUTHORIZED)


class EnterpriseCustomersApi(mixins.ListModelMixin, GenericAPIView):
    """ Display relation between Enterprises and customers
        - display how many customers are tied to enterprises
        - display how many customers are not tied to any enterprise
        """
    serializer_class = EnterpriseCustomersSerializer
    permission_classes = (permissions.IsAdminUser,)
    queryset = Enterprise.objects.all()

    def get(self, request, *args, **kwargs):
        if request.GET.get('elroi_id'):
            self.queryset = Enterprise.objects.filter(elroi_id__exact=request.GET.get('elroi_id'))

        return self.list(request, *args, **kwargs)

    def list(self, request, *args, **kwargs):
        response = super(EnterpriseCustomersApi, self).list(request, args, kwargs)
        req = ConsumerRequest.objects.all()
        total_customers = Customer.objects.exclude(customer__in=req)
        response.data['total_untied_customers'] = total_customers.count()
        response.data['total_existing_customers'] = req.count()
        return response


class EnterpriseApi(mixins.ListModelMixin, mixins.CreateModelMixin, mixins.UpdateModelMixin,GenericAPIView):
    """
    Class used to manage or to update details for enterprise
    - set up or manage payment information
    """
    serializer_class = EnterprisePaymentSerializer
    permission_classes = (permissions.IsAdminUser,)
    queryset = Enterprise.objects.all()

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        data = request.data.copy()
        data['updated_by'] = request.user.id
        serializer = self.serializer_class(data=data)
        if serializer.is_valid():
            try:
                Enterprise.objects.filter(
                    elroi_id__exact=data.get('elroi_id'),
                    user_id=request.user.id
                ).update(
                    payment=data.get('payment')
                )
                enterprise = self.queryset.get(elroi_id__exact=data.get('elroi_id'))
                return Response({
                    'elroi_id': enterprise.elroi_id,
                    'payment': enterprise.payment,
                    'updated_by': enterprise.user_id
                }, status=status.HTTP_200_OK)
            except IntegrityError:
                return Response({"error": "You can't update the elroi_id value"},
                                status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class EnterpriseActivityApi(mixins.ListModelMixin, GenericAPIView):
    """
    Display user's activity log
    """
    serializer_class = EnterpriseActivitySerializer
    permission_classes = (permissions.IsAdminUser,)
    queryset = ActivityLog.objects.all()

    def get(self, request, *args, **kwargs):
        user = request.user
        if hasattr(user, 'enterprise'):
            self.queryset = ActivityLog.objects.filter(elroi_id__exact=user.enterprise.elroi_id)
            return self.list(request, *args, **kwargs)
        else:
            return Response({"error": "No logs were found for this enterprise"}, status=status.HTTP_400_BAD_REQUEST)
