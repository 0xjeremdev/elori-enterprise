from datetime import datetime, timedelta

from rest_framework import mixins, status
from rest_framework import permissions
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from rest_framework.views import APIView
from django.template.loader import render_to_string

from api.v1.accounts.models import Enterprise
from api.v1.accounts.utlis import SendUserEmail
from api.v1.analytics.mixins import LoggingMixin
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.consumer_request.serializers import (
    ConsumerRequestSerializer,
    PeriodParameterSerializer,
)
from api.v1.enterprise.constants import Const_Email_Templates
from api.v1.enterprise.models import EnterpriseEmailType, EnterpriseEmailTemplateModel


class ConsumerRequestAPI(
        LoggingMixin,
        mixins.ListModelMixin,
        mixins.CreateModelMixin,
        mixins.UpdateModelMixin,
        mixins.DestroyModelMixin,
        GenericAPIView,
):
    queryset = ConsumerRequest.objects.all()
    serializer_class = ConsumerRequestSerializer
    permission_classes = (permissions.AllowAny, )

    # get the list of consumer requests
    def get(self, request, *args, **kwargs):
        # period = "week"
        # if request.GET.get("period"):
        #     period = request.GET.get("period")

        # if period == "year":
        #     self.queryset = ConsumerRequest.objects.filter(
        #         request_date__year=datetime.today().year)
        # elif period == "month":
        #     self.queryset = ConsumerRequest.objects.filter(
        #         request_date__month=datetime.today().month)
        # elif period == "week":
        #     week_start = datetime.today()
        #     week_start -= timedelta(days=week_start.weekday())
        #     week_end = week_start + timedelta(days=7)
        #     self.queryset = ConsumerRequest.objects.filter(
        #         request_date__gte=week_start, request_date__lt=week_end)
        # elif period == "day":
        #     self.queryset = ConsumerRequest.objects.filter(
        #         request_date__day=datetime.today().day)
        try:
            enterprise = Enterprise.objects.get(id=kwargs["enterprise_id"])
            self.queryset = ConsumerRequest.objects.filter(
                enterprise=enterprise)
            return self.list(request, *args, **kwargs)
        except Enterprise.DoesNotExist:
            return Response(
                {"error": "Enterprise was not found."},
                status=status.HTTP_400_BAD_REQUEST,
            )

    """ overwrite the list method to add extra data """

    def list(self, request, *args, **kwargs):
        response = super(ConsumerRequestAPI, self).list(request, args, kwargs)
        """ add numbers to create progress bar with approved of total """
        response.data["progress"] = {
            "total": self.queryset.count(),
            "approved": self.queryset.filter(status=1).count(),
        }
        return response

    # create new consumer request
    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

    def create(self, request, *args, **kwargs):
        try:
            enterprise = Enterprise.objects.get(
                id=request.data.get("enterprise_id"))
            serializer = self.serializer_class(data=request.data,
                                               context={"request": request})
            if serializer.is_valid():
                serializer.save()
                user_full_name = (
                    f"{serializer.data['first_name']} {serializer.data['last_name']}"
                )
                email_type = EnterpriseEmailType.objects.filter(
                    email_id=1).first()
                email_template = EnterpriseEmailTemplateModel.objects.filter(
                    enterprise=enterprise, email_type=email_type).first()
                message_body = render_to_string(
                    "email/customer/new_request_created.html",
                    {
                        "user_full_name":
                        user_full_name,
                        "content":
                        Const_Email_Templates[0]
                        if email_template == None else email_template.content,
                        "company":
                        enterprise.company_name
                    },
                )
                email_data = {
                    "email_body": message_body,
                    "to_email": serializer.data["email"],
                    "email_subject": "Your request was sent to Elroi",
                }
                SendUserEmail.send_email(email_data)
                return Response(serializer.data,
                                status=status.HTTP_201_CREATED)
            else:
                return Response(serializer.errors,
                                status=status.HTTP_400_BAD_REQUEST)
        except Enterprise.DoesNotExist:
            return Response(
                {"error": "Enterprise was not found."},
                status=status.HTTP_400_BAD_REQUEST,
            )

    # update consumer request
    def put(self, request, *args, **kwargs):
        try:
            consumer_request = ConsumerRequest.objects.get(
                id=request.data["id"])
            serializer = self.serializer_class(consumer_request,
                                               data=request.data,
                                               context={"request": request})
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data,
                                status=status.HTTP_201_CREATED)
            else:
                return Response(serializer.errors,
                                status=status.HTTP_400_BAD_REQUEST)
        except ConsumerRequest.DoesNotExist:
            return Response(
                {"error": "ConsumerRequest was not found."},
                status=status.HTTP_400_BAD_REQUEST,
            )

    # delete consumer request
    def delete(self, request, *args, **kwargs):
        try:
            consumer_request = ConsumerRequest.objects.get(
                id=request.data["id"])
            consumer_request.delete()
            return Response(
                {
                    "success": True,
                    "data": "The object was removed."
                },
                status=status.HTTP_200_OK)
        except ConsumerRequest.DoesNotExist:
            return Response(
                {"error": "ConsumerRequest was not found."},
                status=status.HTTP_400_BAD_REQUEST,
            )


class ConsumerRequestSetStatus(GenericAPIView):
    # serializer_class = ConsumerRequestSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def post(self, request):
        try:
            consumer_request = ConsumerRequest.objects.get(
                id=request.data["id"])
            status_text = ""
            if "status" in request.data:
                consumer_request.status = request.data["status"]
                if consumer_request.status == 1:
                    consumer_request.approved_date = datetime.utcnow()
                    status_text = "approved"
                elif consumer_request.status == 3:
                    status_text = "completed"
                elif consumer_request.status == 4:
                    status_text = "rejected"
            if "extended" in request.data and request.data["extended"] == True:
                consumer_request.extend_requested_date = datetime.utcnow()
                consumer_request.process_end_date = consumer_request.process_end_date + timedelta(
                    days=45)
                consumer_request.request_date = datetime.utcnow()
                status_text = "extended"
            consumer_request.save()
            user_full_name = (
                f"{consumer_request.first_name} {consumer_request.last_name}")
            message_body = render_to_string(
                "email/customer/request_status_update.html",
                {
                    "user_full_name": user_full_name,
                    "status_text": status_text
                },
            )
            email_data = {
                "email_body": message_body,
                "to_email": consumer_request.email,
                "email_subject": "Your request status was updated",
            }
            SendUserEmail.send_email(email_data)
            return Response({
                "success": True,
            }, status=status.HTTP_200_OK)

        except:
            return Response(
                {"error": "Parameter error."},
                status=status.HTTP_400_BAD_REQUEST,
            )


class ConsumerRequestProgressAPI(LoggingMixin, APIView):
    serializer_class = PeriodParameterSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def get(self, request, period):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        status_list = (1, 2, 4)
        try:
            obj_response = {"active": 0, "approved": 0, "rejected": 0}
            obj_result = ConsumerRequest.objects.filter(
                request_date__month=datetime.today().month,
                status__in=status_list)
            if period == "year":
                obj_result = ConsumerRequest.objects.filter(
                    request_date__year=datetime.today().year,
                    status__in=status_list)
            elif period == "week":
                week_start = datetime.today()
                week_start -= timedelta(days=week_start.weekday())
                week_end = week_start + timedelta(days=7)
                obj_result = ConsumerRequest.objects.filter(
                    request_date__gte=week_start,
                    request_date__lt=week_end,
                    status__in=status_list,
                )
            if obj_result.exists():
                total = obj_result.count()
                for item in obj_result:
                    if item.status == 2:
                        obj_response["active"] += 1
                    if item.status == 1:
                        obj_response["approved"] += 1
                    if item.status == 4:
                        obj_response["rejected"] += 1
                """ calculate percentage """
                for k in obj_response:
                    obj_response[k] = round((obj_response[k] * 100) / total, 2)

            return Response(obj_response, status=status.HTTP_200_OK)
        except:
            return Response({"error": "Wrong Url Format"},
                            status=status.HTTP_400_BAD_REQUEST)


class ConsumerRequestMade(LoggingMixin, APIView):
    def get(self, request):
        try:
            """ get completed requests """
            total_confirmed = ConsumerRequest.objects.filter(status=3).count()
            """ get total number of requests """
            total_number = ConsumerRequest.objects.count()
            """ get date for last request made"""
            last_request = ConsumerRequest.objects.latest("request_date")
            return Response(
                {
                    "confirmed": total_confirmed,
                    "total_made": total_number,
                    "last_date": last_request.request_date,
                },
                status=status.HTTP_200_OK,
            )
        except:
            return Response({"error": "Wrong Url Format"},
                            status=status.HTTP_400_BAD_REQUEST)
