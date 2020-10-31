from datetime import datetime, timedelta

from rest_framework import mixins, status
from rest_framework import permissions
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from rest_framework.views import APIView

from api.v1.accounts.models import Customer, Enterprise
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.consumer_request.serializers import ConsumerRequestSerializer, PeriodParameterSerializer


class ConsumerRequestAPI(mixins.ListModelMixin,
                         mixins.CreateModelMixin,
                         mixins.UpdateModelMixin,
                         mixins.DestroyModelMixin,
                         GenericAPIView):
    queryset = ConsumerRequest.objects.all()
    serializer_class = ConsumerRequestSerializer
    permission_classes = (permissions.AllowAny,)

    # get the list of consumer requests
    def get(self, request, *args, **kwargs):
        period = 'week'
        if request.GET.get('period'):
            period = request.GET.get('period')

        if period == 'year':
            self.queryset = ConsumerRequest.objects.filter(request_date__year=datetime.today().year)
        elif period == 'month':
            self.queryset = ConsumerRequest.objects.filter(request_date__month=datetime.today().month)
        elif period == 'week':
            week_start = datetime.today()
            week_start -= timedelta(days=week_start.weekday())
            week_end = week_start + timedelta(days=7)
            self.queryset = ConsumerRequest.objects.filter(request_date__gte=week_start,
                                                           request_date__lt=week_end)
        elif period == 'day':
            self.queryset = ConsumerRequest.objects.filter(request_date__day=datetime.today().day)

        return self.list(request, *args, **kwargs)

    """ overwrite the list method to add extra data """
    def list(self, request, *args, **kwargs):
        response = super(ConsumerRequestAPI, self).list(request, args, kwargs)
        """ add numbers to create progress bar with approved of total """
        response.data['progress'] = {
            "total": self.queryset.count(),
            "approved": self.queryset.filter(status=1).count()
        }
        return response

    # create new consumer request
    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

    def create(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        enterprise = Enterprise.objects.get(pk=request.data.get('enterprise'))
        if serializer.is_valid():
            try:
                customer = Customer.objects.get(email__iexact=request.data.get('email'))
            except Customer.DoesNotExist:
                customer = Customer.objects.create(
                    email=request.data.get('email'),
                    first_name=request.data.get('first_name'),
                    last_name=request.data.get('last_name')
                )
            customer_request = ConsumerRequest.objects.create(
                customer=customer,
                enterprise=enterprise,
                description=request.data.get('description'),
                request_type=request.data.get('request_type'),
                status=request.data.get('status')
            )
            return Response(ConsumerRequestSerializer(customer_request).data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # update consumer request
    def put(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)

    # delete consumer request
    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)


class ConsumerRequestProgressAPI(APIView):
    serializer_class = PeriodParameterSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, period):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        status_list = (1, 2, 4)
        try:
            obj_response = {"active": 0, "approved": 0, "rejected": 0}
            obj_result = ConsumerRequest.objects.filter(request_date__month=datetime.today().month,
                                                        status__in=status_list)
            if period == 'year':
                obj_result = ConsumerRequest.objects.filter(request_date__year=datetime.today().year,
                                                            status__in=status_list)
            elif period == 'week':
                week_start = datetime.today()
                week_start -= timedelta(days=week_start.weekday())
                week_end = week_start + timedelta(days=7)
                obj_result = ConsumerRequest.objects.filter(request_date__gte=week_start,
                                                            request_date__lt=week_end,
                                                            status__in=status_list)
            if obj_result.exists():
                total = obj_result.count()
                for item in obj_result:
                    if item.status == 2:
                        obj_response['active'] += 1
                    if item.status == 1:
                        obj_response['approved'] += 1
                    if item.status == 4:
                        obj_response['rejected'] += 1

                """ calculate percentage """
                for k in obj_response:
                    obj_response[k] = round((obj_response[k] * 100) / total, 2)

            return Response(obj_response, status=status.HTTP_200_OK)
        except:
            return Response({'error': 'Wrong Url Format'}, status=status.HTTP_400_BAD_REQUEST)


class ConsumerRequestMade(APIView):
    def get(self, request):
        try:
            """ get completed requests """
            total_confirmed = ConsumerRequest.objects.filter(status=3).count()
            """ get total number of requests """
            total_number = ConsumerRequest.objects.count()
            """ get date for last request made"""
            last_request = ConsumerRequest.objects.latest('request_date')
            return Response({
                "confirmed": total_confirmed,
                "total_made": total_number,
                "last_date": last_request.request_date,
            }, status=status.HTTP_200_OK)
        except:
            return Response({'error': 'Wrong Url Format'}, status=status.HTTP_400_BAD_REQUEST)
