import os

from django.conf import settings
from django.core import serializers
from django.db import IntegrityError
from rest_framework import mixins
from rest_framework import status, permissions
from rest_framework.generics import GenericAPIView
from rest_framework.parsers import MultiPartParser, FormParser, FileUploadParser
from rest_framework.response import Response

from api.v1.accounts.models import Enterprise
from api.v1.analytics.models import ActivityLog
from api.v1.assessment.models import Questionnaire, Assessment, AssessmentResults
from api.v1.assessment.serializers import AssessmentSerializer, AssessmentResultSerializer
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.elroi_admin.models import AdminEnterpriseConfig
from api.v1.elroi_admin.serializers import EnterpriseTrialSerializer, EnterpriseMaintenanceSerializer, \
    EnterprisePaymentSerializer, EnterpriseCustomersSerializer, EnterpriseActivitySerializer, \
    QuestionnaireApiSerializer, UserGuideUploadApiSerializer
from api.v1.enterprise.models import UserGuideModel, UserGuideUploads
from api.v1.enterprise.serializers import FileSerializer


class EnterpriseTrialConfigApi(mixins.ListModelMixin, mixins.UpdateModelMixin,
                               GenericAPIView):
    """
    Configuration for trial packages for enterprise
    - set up the number of days for trial period
    """
    serializer_class = EnterpriseTrialSerializer
    permission_classes = (permissions.IsAdminUser, )
    queryset = AdminEnterpriseConfig.objects.all()

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
            return Response(serializer.errors,
                            status=status.HTTP_400_BAD_REQUEST)

    def update(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)


class EnterpriseMaintenanceApi(mixins.UpdateModelMixin, GenericAPIView):
    """ Used to manage the status of the enterprise
        - put the enterprise profile offline
        """
    serializer_class = EnterpriseMaintenanceSerializer
    permission_classes = (permissions.IsAdminUser, )
    queryset = Enterprise.objects.all()

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
                        user__id=request.user.id).update(
                            is_active=data.get('is_active'),
                            turn_off_date=data.get('turn_off_date'))

                    enterprise = self.queryset.get(
                        elroi_id__exact=data.get('elroi_id'))
                    return Response(
                        {
                            'elroi_id': enterprise.elroi_id,
                            'trial_start': enterprise.trial_start,
                            'trial_end': enterprise.trial_end,
                            'is_active': enterprise.is_active,
                            'updated_by': enterprise.user_id
                        },
                        status=status.HTTP_200_OK)
                except IntegrityError:
                    return Response(
                        {"error": "You can't update the elroi_id value"},
                        status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response(serializer.errors,
                                status=status.HTTP_400_BAD_REQUEST)
        except Enterprise.DoesNotExist:
            return Response(
                {
                    "error":
                    "Enterprise was not found, or you are not allowed to continue"
                },
                status=status.HTTP_401_UNAUTHORIZED)


# class EnterpriseCustomersApi(mixins.ListModelMixin, GenericAPIView):
#     """ Display relation between Enterprises and customers
#         - display how many customers are tied to enterprises
#         - display how many customers are not tied to any enterprise
#         """
#     serializer_class = EnterpriseCustomersSerializer
#     permission_classes = (permissions.IsAdminUser,)
#     queryset = Enterprise.objects.all()

#     def get(self, request, *args, **kwargs):
#         if request.GET.get('elroi_id'):
#             self.queryset = Enterprise.objects.filter(elroi_id__exact=request.GET.get('elroi_id'))

#         return self.list(request, *args, **kwargs)

#     def list(self, request, *args, **kwargs):
#         response = super(EnterpriseCustomersApi, self).list(request, args, kwargs)
#         req = ConsumerRequest.objects.all()
#         total_customers = Customer.objects.exclude(customer__in=req)
#         response.data['total_untied_customers'] = total_customers.count()
#         response.data['total_existing_customers'] = req.count()
#         return response


class EnterpriseApi(mixins.ListModelMixin, mixins.CreateModelMixin,
                    mixins.UpdateModelMixin, GenericAPIView):
    """
    Class used to manage or to update details for enterprise
    - set up or manage payment information
    """
    serializer_class = EnterprisePaymentSerializer
    permission_classes = (permissions.IsAdminUser, )
    queryset = Enterprise.objects.all()

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        data = request.data.copy()
        data['updated_by'] = request.user.id
        serializer = self.serializer_class(data=data)
        if serializer.is_valid():
            try:
                Enterprise.objects.filter(elroi_id__exact=data.get('elroi_id'),
                                          user_id=request.user.id).update(
                                              payment=data.get('payment'))
                enterprise = self.queryset.get(
                    elroi_id__exact=data.get('elroi_id'))
                return Response(
                    {
                        'elroi_id': enterprise.elroi_id,
                        'payment': enterprise.payment,
                        'updated_by': enterprise.user_id
                    },
                    status=status.HTTP_200_OK)
            except IntegrityError:
                return Response(
                    {"error": "You can't update the elroi_id value"},
                    status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(serializer.errors,
                            status=status.HTTP_400_BAD_REQUEST)


class EnterpriseActivityApi(mixins.ListModelMixin, GenericAPIView):
    """
    Display user's activity log
    """
    serializer_class = EnterpriseActivitySerializer
    permission_classes = (permissions.IsAdminUser, )
    queryset = ActivityLog.objects.all()

    def get(self, request, *args, **kwargs):
        user = request.user
        if hasattr(user, 'enterprise'):
            self.queryset = ActivityLog.objects.filter(
                elroi_id__exact=user.enterprise.elroi_id)
            return self.list(request, *args, **kwargs)
        else:
            return Response(
                {"error": "No logs were found for this enterprise"},
                status=status.HTTP_400_BAD_REQUEST)


class QuestionnaireApi(mixins.ListModelMixin, mixins.CreateModelMixin,
                       GenericAPIView):
    """
    Use questionnaire to determine type of assessments
    """
    serializer_class = QuestionnaireApiSerializer
    permission_classes = (permissions.IsAdminUser, )
    queryset = Questionnaire.objects.all()

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)


class AssessmentApi(mixins.ListModelMixin, mixins.CreateModelMixin,
                    mixins.DestroyModelMixin, mixins.UpdateModelMixin,
                    GenericAPIView):
    """
    Assessment for administration, can create, update, delete and configure
    assessment to be displayed for enterprise or user
    """
    serializer_class = AssessmentSerializer
    permission_classes = (permissions.IsAdminUser, )
    queryset = Assessment.objects.all()

    def get(self, request, *args, **kwargs):
        self.queryset = Assessment.objects.filter(created_by=request.user)
        return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)

    def delete(self, request, *args, **kwargs):
        return self.delete(request, *args, **kwargs)


class AssessmentResultApi(mixins.ListModelMixin, GenericAPIView):
    """
    Assessment's results
    """
    serializer_class = AssessmentResultSerializer
    permission_classes = (permissions.IsAdminUser, )
    queryset = AssessmentResults.objects.all()

    def get(self, request, *args, **kwargs):
        try:
            self.queryset = AssessmentResults.objects.filter(
                assessment_id=request.data.get('id'),
                assessment__created_by=request.user.id)
            return self.list(request, *args, **kwargs)

        except AssessmentResults.DoesNotExist:
            return Response({"error": "Assessment was not found"},
                            status=status.HTTP_400_BAD_REQUEST)


class UserGuideUploadApi(mixins.ListModelMixin, GenericAPIView):
    serializer_class = UserGuideUploadApiSerializer
    permission_classes = (permissions.IsAdminUser, )
    parser_classes = (
        MultiPartParser,
        FormParser,
        FileUploadParser,
    )

    def get(self, request, *args, **kwargs):
        self.queryset = UserGuideModel.objects.filter(
            elroi_id__exact=request.user.enterprise.elroi_id)
        return self.list(request, *args, **kwargs)

    def list(self, request, *args, **kwargs):
        response = super(UserGuideUploadApi,
                         self).list(request, *args, **kwargs)
        uploads_obj = []
        for upload_file in self.queryset:
            files = [
                '/media/user_guide/' + str(guide_file.file)
                for guide_file in upload_file.uploads.filter(
                    user_guide=upload_file.pk)
            ]
            uploads_obj.extend(files)

        response.data['uploads'] = uploads_obj
        return response

    def post(self, request, *args, **kwargs):
        try:
            data = {}
            file_obj = {}
            if request.user and hasattr(request.user, 'enterprise'):
                data['enterprise'] = request.user.enterprise
                data['elroi_id'] = request.user.enterprise.elroi_id
            else:
                if request.data.get('elroi_id'):
                    data['elroi_id'] = request.data.get('elroi_id')
            if request.data.get('title'):
                data['title'] = request.data.get('title')
            if request.data.get('content'):
                data['content'] = request.data.get('content')
            data['created_by'] = request.user
            user_guide = UserGuideModel.objects.create(**data)
            if request.FILES['file']:
                try:
                    file = request.FILES['file']
                    open(
                        os.path.join(settings.UPLOAD_USER_GUIDE_FOLDER,
                                     file.name), 'wb').write(file.file.read())
                    upload = UserGuideUploads.objects.create(
                        user_guide=user_guide, file=file)
                    file_obj = FileSerializer(upload).data
                except FileNotFoundError:
                    return Response({"error": "File was not uploaded."},
                                    status=status.HTTP_400_BAD_REQUEST)
            guide_obj = UserGuideUploadApiSerializer(user_guide).data
            result = {"guide": guide_obj, "upload": file_obj}
            return Response(result, status=status.HTTP_200_OK)
        except AttributeError:
            return Response({"error": "Something went wrong."},
                            status=status.HTTP_400_BAD_REQUEST)
