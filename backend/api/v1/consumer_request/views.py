import csv
import pdfkit
from datetime import datetime, timedelta
from rest_framework import mixins, status
from rest_framework import permissions
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.parsers import MultiPartParser, FormParser, FileUploadParser
from django.template.loader import render_to_string
from django.db.models import Q
from django.http import HttpResponse
from django.views import View
from api.v1.accounts.models import Enterprise
from api.v1.accounts.utlis import SendUserEmail
from api.v1.analytics.mixins import LoggingMixin
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.consumer_request.serializers import (
    ConsumerRequestSerializer, ConsumerRequestQuestionSerializer,
    PeriodParameterSerializer, ConsumerReportSerializer,
    ConsumerRequestSendSerializer)
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
                    type_name="confirm").first()
                email_template = EnterpriseEmailTemplateModel.objects.filter(
                    enterprise=enterprise, email_type=email_type).first()
                message_body = render_to_string(
                    "email/customer/new_request_created.html",
                    {
                        "user_full_name":
                        user_full_name,
                        "content":
                        Const_Email_Templates["confirm"]
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


class ConsumerRequestQuestionView(GenericAPIView):
    serializer_class = ConsumerRequestQuestionSerializer
    permission_classes = (permissions.AllowAny, )
    parser_classes = (MultiPartParser, FormParser, FileUploadParser)

    def post(self, request):
        serializer = self.serializer_class(data=request.data,
                                           context={"request": request})
        try:
            if serializer.is_valid(raise_exception=True):
                data = serializer.save()
                return Response({"success": True},
                                status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({
                "success": False,
                "error": str(e)
            },
                            status=status.HTTP_400_BAD_REQUEST)


class ConsumerRequestSetStatus(LoggingMixin, GenericAPIView):
    # serializer_class = ConsumerRequestSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def post(self, request):
        try:
            consumer_request = ConsumerRequest.objects.get(
                id=request.data["id"])
            comment = ""
            if "comment" in request.data:
                comment = request.data["comment"]
            email_type_name = ""
            if "status" in request.data:
                consumer_request.status = request.data["status"]
                if consumer_request.status == 1:
                    consumer_request.approved_date = datetime.utcnow()
                    email_type_name = "acceptance"
                elif consumer_request.status == 3:
                    email_type_name = "complete_dispose"
                elif consumer_request.status == 4:
                    email_type_name = "reject_noinfo"
            if "extended" in request.data and request.data[
                    "extended"] == True and consumer_request.is_extended == False:
                consumer_request.is_extended = True
                consumer_request.extend_requested_date = datetime.utcnow()
                timeframe = consumer_request.timeframe
                consumer_request.extend_requested_days += 30 if timeframe == 0 else 45
                consumer_request.process_end_date = consumer_request.process_end_date + timedelta(
                    days=30 if timeframe == 0 else 45)
                consumer_request.request_date = datetime.utcnow()
                email_type_name = "extension_GDPR" if consumer_request.timeframe == 0 else "extension_CCPA"
            if email_type_name == "":
                raise Exception()
            consumer_request.save()
            email_type = EnterpriseEmailType.objects.filter(
                type_name=email_type_name).first()
            email_template = EnterpriseEmailTemplateModel.objects.filter(
                enterprise=consumer_request.enterprise,
                email_type=email_type).first()
            user_full_name = (
                f"{consumer_request.first_name} {consumer_request.last_name}")
            message_body = render_to_string(
                "email/customer/request_status_update.html",
                {
                    "user_full_name":
                    user_full_name,
                    "content":
                    Const_Email_Templates[email_type_name]
                    if email_template == None else email_template.content,
                    "comment":
                    comment
                },
            )
            email_data = {
                "email_body":
                message_body,
                "to_email":
                consumer_request.email,
                "email_subject":
                "Your request status was updated",
                "email_template":
                None if email_template is None else email_template
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


class ConsumerRequestSend(LoggingMixin, GenericAPIView):
    serializer_class = ConsumerRequestSendSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def post(self, request):
        try:
            serializer = self.serializer_class(data=request.data,
                                               context={"request": request})
            serializer.is_valid(raise_exception=True)
            data = serializer.data
            consumer_request = ConsumerRequest.objects.get(id=data.get("id"))
            email_type = EnterpriseEmailType.objects.filter(
                type_name=data.get("email_type")).first()
            email_template = EnterpriseEmailTemplateModel.objects.filter(
                enterprise=consumer_request.enterprise,
                email_type=email_type).first()
            user_full_name = (
                f"{consumer_request.first_name} {consumer_request.last_name}")
            message_body = render_to_string(
                "email/customer/request_status_update.html",
                {
                    "user_full_name":
                    user_full_name,
                    "content":
                    Const_Email_Templates[data.get("email_type")]
                    if email_template == None else email_template.content,
                    "comment":
                    ""
                },
            )
            email_data = {
                "email_body": message_body,
                "to_email": consumer_request.email,
                "email_subject": "Your request was processed",
                "email_template":
                None if email_template is None else email_template,
                "attachment": request.FILES.get("attachment")
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


class ConsumerReport(View):
    def get(self, request, *args, **kwargs):
        try:
            enterprise = Enterprise.objects.get(id=kwargs["enterprise_id"])
            start_date = request.GET.get("start_date")
            end_date = request.GET.get("end_date")
            timeframe = request.GET.get("timeframe")
            status = request.GET.get("status")
            queryset = ConsumerRequest.objects.filter(enterprise=enterprise)
            if start_date != None and end_date != None:
                queryset &= ConsumerRequest.objects.filter(
                    request_date__range=[start_date, end_date])
            if timeframe != None:
                queryset &= ConsumerRequest.objects.filter(timeframe=timeframe)
            if status != None:
                queryset &= ConsumerRequest.objects.filter(status=status)
            data = list(queryset.values())
            keys = [
                "Email", "First Name", "Last Name", "State Resident",
                "Timeframe", "Status", "Request Type", "Request Date",
                "End Date", "Approved Date", "Extended Date", "Extended Days"
            ]
            report_type = request.GET.get("report_type")
            if report_type == "csv":
                return self.GetCSV(data, keys)
            elif report_type == "pdf":
                return self.GetPDF(data, keys)
            else:
                return HttpResponse(content="Invaid parameter")

        except:
            return HttpResponse(content="Invaid parameter")

    def GetCSV(self, data, keys):
        reponse = HttpResponse(content_type="text/csv")
        file_name = 'compliance_report' + datetime.today().strftime('%Y-%m-%d')
        reponse[
            'Content-Disposition'] = 'attachement; filename="{0}.csv"'.format(
                file_name)
        writer = csv.writer(reponse)
        writer.writerow(keys)
        for item in data:
            serializer = ConsumerReportSerializer(data=item)
            serializer.is_valid()
            writer.writerow(serializer.get_list())
        return reponse

    def GetPDF(self, data, keys):
        list_data = []
        for item in data:
            serializer = ConsumerReportSerializer(data=item)
            serializer.is_valid()
            list_data.append(serializer.get_list())
        html = render_to_string("report/report_pdf.html", {
            "data": list_data,
            "keys": keys
        })
        pdf_settings = {
            'page-size': 'Letter',
            'margin-top': '0.75in',
            'margin-right': '0.75in',
            'margin-bottom': '0.75in',
            'margin-left': '0.75in',
            'encoding': "UTF-8",
            'no-outline': None,
        }
        pdf = pdfkit.from_string(html, False, options=pdf_settings)
        response = HttpResponse(pdf, content_type="application/pdf")
        file_name = 'compliance_report' + datetime.today().strftime('%Y-%m-%d')
        response[
            'Content-Disposition'] = 'attachement; filename="{0}.pdf"'.format(
                file_name)
        return response


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
