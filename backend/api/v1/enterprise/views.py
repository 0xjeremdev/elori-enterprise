from typing import re

from django.conf import settings
from django.template.loader import render_to_string
from django.urls import reverse
from rest_framework import mixins, permissions, status
from rest_framework.exceptions import AuthenticationFailed, ValidationError
from rest_framework.generics import GenericAPIView
from rest_framework.parsers import MultiPartParser, FormParser, FileUploadParser
from rest_framework.response import Response
from rest_framework.views import APIView
from django.utils.encoding import force_bytes, force_text
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode

from api.v1.accounts.utlis import SendUserEmail
from api.v1.analytics.mixins import LoggingMixin
from api.v1.assessment.models import EnterpriseQuestionnaire, Assessment
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import (UserGuideModel, CustomerConfiguration,
                                      EnterpriseConfigurationModel,
                                      EnterpriseInviteModel,
                                      EnterpriseEmailTemplateModel,
                                      EnterpriseEmailType,
                                      EnterpriseQuestionModel)
from ..accounts.models import Enterprise
from api.v1.enterprise.serializers import (
    UserGuideSerializer, CustomerConfigurationSerializer,
    CustomerSummarizeSerializer, RequestTrackerSerializer,
    EnterpriseConfigurationSerializer, FileSerializer,
    EnterpriseAccountSettingsSerializer, EnterpriseInviteSerializer,
    EnterpriseEmailTypeSerializer, EnterpriseEmailTemplateSerializer,
    EnterpriseQuestionSerializer)
from .constants import Const_Email_Templates


class UserGuide(LoggingMixin, mixins.ListModelMixin, mixins.CreateModelMixin,
                GenericAPIView):
    """ user guide """

    queryset = UserGuideModel.objects.all()
    serializer_class = UserGuideSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def get(self, request, *args, **kwargs):
        if request.GET.get("enterprise_id"):
            self.queryset = UserGuideModel.objects.filter(
                owner__id=request.GET.get("enterprise_id")).prefetch_related(
                    "uploads")
        else:
            self.queryset = UserGuideModel.objects.filter(
                created_by=request.user).prefetch_related("uploads")
        return self.list(request, *args, **kwargs)

    """ overwrite list method to assign the list of uploaded files based on guide id """

    def list(self, request, *args, **kwargs):
        response = super(UserGuide, self).list(request, *args, **kwargs)
        uploads = []
        for upload_file in self.queryset:
            files = [
                str(guide_file.file)
                for guide_file in upload_file.uploads.filter(
                    user_guide=upload_file.pk)
            ]
            uploads.extend(files)
        response.data["uploads"] = uploads
        return response

    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)


class UserGuideUpload(LoggingMixin, APIView):
    """ Upload file for specific guide id"""

    permission_classes = (permissions.IsAuthenticated, )
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        file_serializer = FileSerializer(data=request.data)
        if file_serializer.is_valid():
            file_serializer.save()
            return Response(file_serializer.data,
                            status=status.HTTP_201_CREATED)
        else:
            return Response(file_serializer.errors,
                            status=status.HTTP_400_BAD_REQUEST)


class CustomerConfiguration(
        LoggingMixin,
        mixins.ListModelMixin,
        mixins.CreateModelMixin,
        mixins.UpdateModelMixin,
        mixins.DestroyModelMixin,
        GenericAPIView,
):
    queryset = CustomerConfiguration.objects.all()
    serializer_class = CustomerConfigurationSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    # create new configuration
    def post(self, request, *args, **kwargs):
        if request.user and hasattr(request.user, "enterprise"):
            return self.create(request, *args, **kwargs)
        return Response(
            {
                "error": "You are not allowed to continue",
            },
            status=status.HTTP_401_UNAUTHORIZED,
        )

    # update configuration
    def put(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)

    # delete configuration
    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)


class CustomerSummarize(LoggingMixin, mixins.ListModelMixin, GenericAPIView):
    queryset = ConsumerRequest.objects.all()
    serializer_class = CustomerSummarizeSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def get(self, request, *args, **kwargs):
        if request.GET.get("id"):
            self.queryset = ConsumerRequest.objects.filter(
                id=request.GET.get("id"))
        return self.list(request, *args, **kwargs)


class RequestTracker(LoggingMixin, mixins.ListModelMixin, GenericAPIView):
    queryset = ConsumerRequest.objects.all()
    serializer_class = RequestTrackerSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def get(self, request, *args, **kwargs):
        if request.GET.get("id"):
            self.queryset = ConsumerRequest.objects.filter(
                elroi_id=request.GET.get("id"))
        return self.list(request, *args, **kwargs)


class NotifyCustomer(LoggingMixin, APIView):
    permission_classes = (permissions.IsAuthenticated, )

    def post(self, request, *args, **kwargs):
        request_id = request.data.get("request_id")
        try:
            db_res = ConsumerRequest.objects.get(id=request_id)
            customer_email = db_res.customer.email
            user_full_name = db_res.customer.full_name()
            email_template_data = {"user_full_name": user_full_name}
            message_body = render_to_string("email/first_45_days_period.html",
                                            email_template_data)
            email_data = {
                "email_body": message_body,
                "to_email": customer_email,
                "email_subject": "First add 45 days",
            }
            SendUserEmail.send_email(email_data)
            return Response(
                {
                    "success": True,
                    "message": "Email was sent."
                },
                status=status.HTTP_200_OK,
            )
        except ConsumerRequest.DoesNotExist:
            return Response({"error": "Invalid customer"},
                            status=status.HTTP_404_NOT_FOUND)


class ExtendedVsNewRequests(LoggingMixin, APIView):
    permission_classes = (permissions.IsAuthenticated, )

    def get(self, request, *args, **kwargs):
        user_id = request.user.id
        try:
            enterprise_db = ConsumerRequest.objects.filter(
                enterprise__user_id=user_id)
            if enterprise_db.exists():
                total_requsts = enterprise_db.count()
                extended = enterprise_db.filter(extend_requested=1).count()
                new_requests = enterprise_db.filter(extend_requested=0).count()
                extended_percent = round((extended * 100) / total_requsts, 2)
                new_percent = round(100 - extended_percent)
                return Response(
                    {
                        "total": total_requsts,
                        "extended": extended,
                        "new": new_requests,
                        "percentage": {
                            "extended": f"{extended_percent}%",
                            "new": f"{new_percent}%",
                        },
                    },
                    status=status.HTTP_200_OK,
                )
            else:
                return Response(
                    {
                        "total": 0,
                        "extended": 0,
                        "new": 0,
                        "percentage": {
                            "extended": "0%",
                            "new": "0%"
                        },
                    },
                    status=status.HTTP_200_OK,
                )
        except ConsumerRequest.DoesNotExist:
            return Response({"error": "Data not found."},
                            status=status.HTTP_404_NOT_FOUND)


class EnterpriseConfiguration(
        LoggingMixin,
        mixins.ListModelMixin,
        mixins.CreateModelMixin,
        mixins.UpdateModelMixin,
        mixins.DestroyModelMixin,
        GenericAPIView,
):
    serializer_class = EnterpriseConfigurationSerializer

    permission_classes = (permissions.IsAuthenticated, )

    # parser_classes = (MultiPartParser, FormParser, FileUploadParser)
    def get(self, request, *args, **kwargs):
        try:
            self.queryset = EnterpriseConfigurationModel.objects.filter(
                enterprise_id__id=kwargs["enterprise_id"])
            return self.list(request, *args, **kwargs)
        except EnterpriseConfigurationModel.DoesNotExist:
            return Response({"error": "Page not found"},
                            status=status.HTTP_404_NOT_FOUND)

    def list(self, request, *args, **kwargs):
        response = super(EnterpriseConfiguration,
                         self).list(request, args, kwargs)
        if len(response.data["results"]) == 0:
            return Response({"success": False}, status=status.HTTP_200_OK)
        return Response(
            {
                "success": True,
                "data": response.data["results"][0]
            },
            status=status.HTTP_200_OK,
        )

    # create new configuration
    def post(self, request, *args, **kwargs):
        try:
            configuration = EnterpriseConfigurationModel.objects.get(
                enterprise_id=request.data.get("enterprise_id"),
                enterprise_id__user=request.user,
            )
            serializer = self.serializer_class(configuration,
                                               data=request.data,
                                               context={"request": request})
            if serializer.is_valid(raise_exception=True):
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                return Response(serializer.errors,
                                status=status.HTTP_400_BAD_REQUEST)

        except EnterpriseConfigurationModel.DoesNotExist:
            if request.user and hasattr(request.user, "enterprise"):
                try:
                    return self.create(request, *args, **kwargs)
                except Exception as e:
                    return Response(
                        {
                            "success": False,
                            "error": str(e),
                        },
                        status=status.HTTP_400_BAD_REQUEST,
                    )
            return Response(
                {
                    "error": "You are not allowed to continue",
                },
                status=status.HTTP_401_UNAUTHORIZED,
            )
        except Exception as e:
            return Response(
                {
                    "success": False,
                    "error": str(e),
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

    # delete configuration
    def delete(self, request, *args, **kwargs):
        self.queryset = EnterpriseConfigurationModel.objects.get(
            enterprise_id__user=request.user,
            enterprise_id__elroi_id=request.data.get("elroi_id"),
        )
        return self.destroy(request, *args, **kwargs)


class EnterpriseWebform(
        GenericAPIView,
        mixins.ListModelMixin,
):
    serializer_class = EnterpriseConfigurationSerializer
    permission_classes = (permissions.AllowAny, )

    def get(self, request, *args, **kwargs):
        try:
            self.queryset = EnterpriseConfigurationModel.objects.filter(
                website_launched_to=kwargs["web_id"])
            return self.list(request, *args, **kwargs)
        except EnterpriseConfigurationModel.DoesNotExist:
            return Response({"error": "Page not found"},
                            status=status.HTTP_404_NOT_FOUND)

    def list(self, request, *args, **kwargs):
        response = super(EnterpriseWebform, self).list(request, args, kwargs)
        if len(response.data["results"]) == 0:
            return Response({"success": False}, status=status.HTTP_200_OK)
        return Response(
            {
                "success": True,
                "data": response.data["results"][0]
            },
            status=status.HTTP_200_OK,
        )


class EnterpriseQuestionView(GenericAPIView):

    serializer_class = EnterpriseQuestionSerializer
    permission_classes = (permissions.AllowAny, )

    def get(self, request, *args, **kwargs):
        enterprise = Enterprise.objects.filter(
            pk=kwargs["enterprise_id"]).first()
        if enterprise == None:
            return Response(
                {
                    "success": False,
                    "error": "You are not allowed to continue",
                },
                status=status.HTTP_401_UNAUTHORIZED,
            )
        questions = EnterpriseQuestionModel.objects.filter(
            enterprise=enterprise).order_by("pk")
        return Response(
            {
                "success": True,
                "data": list(questions.values()),
            },
            status=status.HTTP_200_OK,
        )

    def post(self, request, *args, **kwargs):
        user = request.user
        try:
            enterprise = Enterprise.objects.filter(
                pk=kwargs["enterprise_id"]).first()
            if enterprise == None:
                return Response(
                    {
                        "success": False,
                        "error": "You are not allowed to continue",
                    },
                    status=status.HTTP_401_UNAUTHORIZED,
                )
            serializer = self.serializer_class(data=request.data)
            serializer.is_valid(raise_exception=True)
            question = EnterpriseQuestionModel.objects.create(
                enterprise=enterprise,
                content=request.data["content"],
                question_type=request.data["question_type"])
            return Response(
                {"success": True},
                status=status.HTTP_200_OK,
            )
        except:
            return Response(
                {
                    "success": False,
                    "error": "Parameter error"
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

    def patch(self, request, *args, **kwargs):
        user = request.user
        try:
            enterprise = Enterprise.objects.filter(
                pk=kwargs["enterprise_id"]).first()
            if enterprise == None:
                return Response(
                    {
                        "success": False,
                        "error": "You are not allowed to continue",
                    },
                    status=status.HTTP_401_UNAUTHORIZED,
                )
            question = EnterpriseQuestionModel.objects.filter(
                enterprise=enterprise, pk=request.data["question_id"])
            question.update(enterprise=enterprise,
                            content=request.data["content"],
                            question_type=request.data["question_type"])
            return Response(
                {"success": True},
                status=status.HTTP_200_OK,
            )
        except:
            return Response(
                {
                    "success": False,
                    "error": "Parameter error"
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

    def delete(self, request, *args, **kwargs):
        user = request.user
        try:
            enterprise = Enterprise.objects.filter(
                pk=kwargs["enterprise_id"]).first()
            if enterprise == None:
                return Response(
                    {
                        "success": False,
                        "error": "You are not allowed to continue",
                    },
                    status=status.HTTP_401_UNAUTHORIZED,
                )
            question = EnterpriseQuestionModel.objects.filter(
                enterprise=enterprise, pk=request.data["question_id"])
            question.delete()
            return Response(
                {"success": True},
                status=status.HTTP_200_OK,
            )
        except:
            return Response(
                {
                    "success": False,
                    "error": "Parameter error"
                },
                status=status.HTTP_400_BAD_REQUEST,
            )


def validate_email_format(email):
    """ method to validate email address """
    regex = "^[a-z0-9]+[\._]?[a-z0-9]+[@]\w+[.]\w{2,3}$"
    if re.search(regex, email):
        return True
    return False


class EnterpriseAssessmentShareLink(LoggingMixin, GenericAPIView):
    """
    get the assessment share link to be sent by email
    """
    def get(self, request, elroi_id, *args, **kwargs):
        try:
            e_q = EnterpriseQuestionnaire.objects.get(
                enterprise__elroi_id=elroi_id)
            if e_q.is_yes:
                assessment = Assessment.objects.get(
                    question_id=e_q.question_id,
                    answer_id=e_q.answer_id,
                    allow_enterprise=True,
                )
                return Response(
                    {
                        "id":
                        assessment.id,
                        "title":
                        assessment.title,
                        "assessment_url":
                        reverse(
                            "view_shared_assessment",
                            kwargs={"token": assessment.share_hash},
                        ),
                    },
                    status=status.HTTP_200_OK,
                )
        except EnterpriseQuestionnaire.DoesNotExist:
            return Response(
                {
                    "error":
                    "Enterprise has no assessment or questionnaire was not completed."
                },
                status=status.HTTP_404_NOT_FOUND,
            )

    def post(self, request, elroi_id, *args, **kwargs):
        try:
            email = request.data.get("email")
            if validate_email_format(email):
                assessment = Assessment.objects.get(
                    id=request.data.get("assessment_id"))
                assessment_url = reverse(
                    "view_shared_assessment",
                    kwargs={"token": assessment.share_hash})
                front_url = (
                    f"{settings.FRONTEND_URL}/assessment/{assessment.share_hash}"
                )
                email_template_data = {"assessment_url": front_url}
                email_body = render_to_string(
                    "email/assessment_share_link.html", email_template_data)
                email_data = {
                    "email_body": email_body,
                    "to_email": email,
                    "email_subject": "Assessment Share Url",
                }
                SendUserEmail.send_email(email_data)
                return Response({"api_url": assessment_url},
                                status=status.HTTP_200_OK)
            else:
                return Response(
                    {"error": "Please provide valid email address"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

        except Assessment.DoesNotExist:
            return Response({"error": "Assessment was not found."},
                            status=status.HTTP_404_NOT_FOUND)


class EnterpriseAccountSettings(LoggingMixin, GenericAPIView):
    """
    Account settings
    """

    serializer_class = EnterpriseAccountSettingsSerializer
    permission_classes = (permissions.IsAuthenticated, )
    parser_classes = (MultiPartParser, FormParser, FileUploadParser)

    def get(self, request, *args, **kwargs):
        user = request.user
        if hasattr(user, "enterprise"):
            enterprise = user.enterprise
            return Response(
                EnterpriseAccountSettingsSerializer(enterprise,
                                                    context={
                                                        "request": request
                                                    }).data,
                status=status.HTTP_200_OK,
            )
        else:
            return Response({
                "error": "Data not found",
            },
                            status=status.HTTP_400_BAD_REQUEST)

    def post(self, request, *args, **kwargs):
        user = request.user
        if hasattr(user, "enterprise"):
            enterprise = user.enterprise
            serializer = self.serializer_class(enterprise,
                                               data=request.data,
                                               context={"request": request})
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                return Response(serializer.errors,
                                status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"error": "Not allowed to continue"},
                            status=status.HTTP_400_BAD_REQUEST)


class EnterpriseEmailTypeView(GenericAPIView):

    serializer_class = EnterpriseEmailTypeSerializer
    permission_classes = (permissions.AllowAny, )

    def get(self, request, *args, **kwargs):
        email_types = EnterpriseEmailType.objects.all()
        print(email_types)
        return Response(
            list(email_types.values()),
            status=status.HTTP_200_OK,
        )


class EnterpriseEmailTemplate(LoggingMixin, GenericAPIView):
    """
    Account settings
    """

    serializer_class = EnterpriseEmailTemplateSerializer
    permission_classes = (permissions.IsAuthenticated, )
    parser_classes = (MultiPartParser, FormParser, FileUploadParser)

    def get(self, request, *args, **kwargs):
        user = request.user
        if hasattr(user, "enterprise"):
            enterprise = user.enterprise
            email_type = EnterpriseEmailType.objects.filter(
                email_id=kwargs["email_type"]).first()
            if email_type == None:
                return Response({"error": "Wrong email type."},
                                status=status.HTTP_400_BAD_REQUEST)
            if not EnterpriseEmailTemplateModel.objects.filter(
                    enterprise=enterprise, email_type=email_type).exists():
                EnterpriseEmailTemplateModel.objects.create(
                    enterprise=enterprise,
                    email_type=email_type,
                    content=Const_Email_Templates[email_type.type_name])
            emailTemp = EnterpriseEmailTemplateModel.objects.filter(
                enterprise=enterprise,
                email_type=kwargs["email_type"]).first()
            return Response(
                EnterpriseEmailTemplateSerializer(emailTemp).data,
                status=status.HTTP_200_OK,
            )
        else:
            return Response({
                "error": "Data not found",
            },
                            status=status.HTTP_400_BAD_REQUEST)

    def post(self, request, *args, **kwargs):
        user = request.user
        if hasattr(user, "enterprise"):
            enterprise = user.enterprise
            email_type = EnterpriseEmailType.objects.filter(
                email_id=kwargs["email_type"]).first()
            if email_type == None:
                return Response({"error": "Wrong email type."},
                                status=status.HTTP_400_BAD_REQUEST)
            if not EnterpriseEmailTemplateModel.objects.filter(
                    enterprise=enterprise, email_type=email_type).exists():
                EnterpriseEmailTemplateModel.objects.create(
                    enterprise=enterprise, email_type=email_type)
            emailTemp = EnterpriseEmailTemplateModel.objects.filter(
                enterprise=enterprise, email_type=email_type).first()
            if "attachment" in request.FILES:
                attachment = request.FILES["attachment"]
                emailTemp.file_name = attachment.name
                emailTemp.file_type = attachment.content_type
            serializer = self.serializer_class(emailTemp,
                                               data=request.data,
                                               context={"request": request})
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                return Response(serializer.errors,
                                status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"error": "Not allowed to continue"},
                            status=status.HTTP_400_BAD_REQUEST)


class EnterpriseInvitation(LoggingMixin, GenericAPIView):
    """
    Send Invitation to Customer
    """
    serializer_class = EnterpriseInviteSerializer
    permission_classes = (permissions.IsAuthenticated, )

    def post(self, request, *args, **kwargs):
        user = request.user
        if hasattr(user, "enterprise"):
            enterprise = user.enterprise
            serializer = self.serializer_class(
                data=request.data, context={"enterprise": enterprise})
            if serializer.is_valid():
                invite = serializer.save()
                # message_body = render_to_string(
                #     "email/enterprise/enterprise_invite.html", {
                #         "user_full_name": user.full_name,
                #         "email": invite["email"]
                #     })
                # email_data = {
                #     "email_body": message_body,
                #     "to_email": user.email,
                #     "email_subject": "Invitation Sent",
                # }
                # SendUserEmail.send_email(email_data)
                join_url = f"{settings.FRONTEND_URL}/customer-join/{urlsafe_base64_encode(force_bytes(invite.invite_key))}"
                message_body = render_to_string(
                    "email/customer/customer_invite.html", {
                        "url": join_url,
                    })
                email_data = {
                    "email_body": message_body,
                    "to_email": invite.email,
                    "email_subject": "Join Invitation",
                }
                SendUserEmail.send_email(email_data)
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                return Response(serializer.errors,
                                status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"error": "Not allowed to continue"},
                            status=status.HTTP_400_BAD_REQUEST)


class GetInvitationInfo(LoggingMixin, GenericAPIView):
    """
    Get Invitation Info by UUID
    """
    permission_classes = (permissions.AllowAny, )

    def get(self, request, *args, **kwargs):
        invite_key = force_text(urlsafe_base64_decode(kwargs.get("uidb64")))
        invite = EnterpriseInviteModel.objects.filter(
            invite_key=invite_key).first()
        if invite == None:
            raise ValidationError("Invitation isn't exist",
                                  code=status.HTTP_400_BAD_REQUEST)
        enterprise_data = EnterpriseAccountSettingsSerializer(
            invite.enterprise, context={
                "request": request
            }).data
        data = {
            "enterprise": {
                "id": invite.enterprise.pk,
                "elroi_id": invite.enterprise.elroi_id,
                "name": invite.enterprise.name,
                "logo": enterprise_data["logo"]
            },
            "email": invite.email
        }
        return Response(data, status=status.HTTP_200_OK)
