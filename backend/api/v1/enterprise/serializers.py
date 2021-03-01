import os

from rest_framework import serializers, status
from rest_framework.exceptions import AuthenticationFailed, ValidationError
from api.v1.accounts.models import Enterprise, Account
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import (UserGuideModel, CustomerConfiguration,
                                      EnterpriseConfigurationModel,
                                      UserGuideUploads, EnterpriseInviteModel,
                                      EnterpriseEmailTemplateModel,
                                      EnterpriseEmailType,
                                      EnterpriseQuestionModel)
from ..consumer_request.utils import validate_filesize, validate_filename


class UserGuideSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserGuideModel
        fields = "__all__"


class FileSerializer(serializers.ModelSerializer):
    file = serializers.FileField(read_only=True)
    name = serializers.CharField(max_length=255, read_only=True)
    size = serializers.IntegerField(read_only=True)

    class Meta:
        model = UserGuideUploads
        fields = ["file", "name", "size"]

    def validate(self, data):
        request = self.context.get("request")
        if not validate_filename(request.FILES.get("file")):
            raise Exception("Invalid filetype")
        if not validate_filesize(request.FILES.get("file")):
            raise Exception(
                "Too large filesize. The file should be less than 3MB.")
        return super().validate(data)


class CustomerConfigurationSerializer(serializers.ModelSerializer):
    elroi_id = serializers.SerializerMethodField()

    def get_elroi_id(self, obj):
        return obj.author.elroi_id

    class Meta:
        model = CustomerConfiguration
        fields = "__all__"


class CustomerSummarizeSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(required=True)

    class Meta:
        model = ConsumerRequest
        exclude = ["enterprise"]


class RequestTrackerSerializer(serializers.ModelSerializer):
    elroi_id = serializers.CharField(required=True)

    class Meta:
        model = ConsumerRequest
        fields = (
            "status",
            "request_date",
            "process_end_date",
            "elroi_id",
            "remaining_days",
        )


class EnterpriseConfigurationSerializer(serializers.ModelSerializer):
    elroi_id = serializers.SerializerMethodField()
    logo = serializers.FileField(required=False)
    site_color = serializers.JSONField(required=False)
    site_theme = serializers.JSONField(required=False)
    background_image = serializers.FileField(required=False)
    website_launched_to = serializers.CharField(required=False)
    company_name = serializers.SerializerMethodField()
    resident_state = serializers.BooleanField(required=False)

    def get_elroi_id(self, obj):
        return obj.enterprise_id.user.elroi_id

    def get_company_name(self, obj):
        return obj.enterprise_id.company_name

    class Meta:
        model = EnterpriseConfigurationModel
        fields = "__all__"

    def validate(self, data):
        request = self.context.get("request")
        if "logo" in request.FILES:
            if not validate_filename(request.FILES.get("logo")):
                raise Exception("Invalid filetype")
            if not validate_filesize(request.FILES.get("logo")):
                raise Exception(
                    "Too large filesize. The file should be less than 3MB.")
        if "background_image" in request.FILES:
            if not validate_filename(request.FILES.get("background_image")):
                raise Exception("Invalid filetype")
            if not validate_filesize(request.FILES.get("background_image")):
                raise Exception(
                    "Too large filesize. The file should be less than 3MB.")
        return super().validate(data)


class EnterpriseQuestionSerializer(serializers.ModelSerializer):
    content = serializers.CharField(required=True)
    question_type = serializers.IntegerField(required=True)

    class Meta:
        model = EnterpriseQuestionModel
        fields = [
            "content",
            "question_type",
        ]


class EnterpriseAccountSettingsSerializer(serializers.ModelSerializer):
    elroi_id = serializers.CharField(read_only=True)
    logo = serializers.FileField(required=False)
    site_color = serializers.JSONField(required=False)
    second_color = serializers.JSONField(required=False)
    notification_email = serializers.CharField(required=False)
    additional_emails = serializers.CharField(required=False)
    address = serializers.CharField(required=False)
    company_name = serializers.CharField(required=False)
    timezone = serializers.CharField(required=False)
    time_frame = serializers.CharField(required=False)

    class Meta:
        model = Enterprise
        fields = [
            "elroi_id", "logo", "site_color", "second_color",
            "notification_email", "additional_emails", "address",
            "company_name", "timezone", "time_frame"
        ]

    def validate(self, data):
        request = self.context.get("request")
        if "logo" in request.FILES:
            if not validate_filename(request.FILES.get("logo")):
                raise Exception("Invalid filetype")
            if not validate_filesize(request.FILES.get("logo")):
                raise Exception(
                    "Too large filesize. The file should be less than 3MB.")
        return super().validate(data)


class EnterpriseEmailTypeSerializer(serializers.ModelSerializer):
    email_type = serializers.CharField(required=False)

    class Meta:
        model = EnterpriseEmailType
        fields = [
            "email_type",
        ]


class EnterpriseEmailTemplateSerializer(serializers.ModelSerializer):

    content = serializers.CharField(required=False)
    attachment = serializers.FileField(required=False)

    class Meta:
        model = EnterpriseEmailTemplateModel
        fields = [
            "content",
            "attachment",
        ]

    def validate(self, data):
        request = self.context.get("request")
        if not validate_filename(request.FILES.get("attachment")):
            raise Exception("Invalid filetype")
        if not validate_filesize(request.FILES.get("attachment")):
            raise Exception(
                "Too large filesize. The file should be less than 3MB.")
        return super().validate(data)


class EnterpriseInviteSerializer(serializers.ModelSerializer):
    email = serializers.CharField(min_length=6, max_length=80, required=True)

    class Meta:
        model = EnterpriseInviteModel
        fields = ["email"]

    def validate(self, data):
        if Account.objects.filter(email__iexact=data.get('email')).exists():
            raise ValidationError("Email already exist",
                                  code=status.HTTP_400_BAD_REQUEST)
        return super().validate(data)

    def create(self, validated_data):
        enterprise = self.context.get("enterprise")
        invite = EnterpriseInviteModel.objects.create(enterprise=enterprise,
                                                      **validated_data)
        return invite
