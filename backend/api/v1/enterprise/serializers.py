import os

from rest_framework import serializers, status
from rest_framework.exceptions import AuthenticationFailed, ValidationError
from api.v1.accounts.models import Enterprise, Account
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import (UserGuideModel, CustomerConfiguration,
                                      EnterpriseConfigurationModel,
                                      UserGuideUploads, EnterpriseInviteModel,
                                      EnterpriseEmailTemplateModel)


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
    company_name = serializers.CharField(required=False)
    resident_state = serializers.BooleanField(required=False)
    additional_configuration = serializers.JSONField(required=False)

    # logo = serializers.SerializerMethodField()
    # background_image = serializers.SerializerMethodField()

    # def get_logo(self, obj):
    #     if obj.logo.url:
    #         return self.build_url(obj.logo.url)
    #     else:
    #         return obj.logo

    # def get_background_image(self, obj):
    #     if obj.background_image.url:
    #         return self.build_url(obj.background_image.url)
    #     else:
    #         return obj.background_image

    # def build_url(self, file_url):
    #     request = self.context.get("request")
    #     return request.build_absolute_uri(file_url)

    def get_elroi_id(self, obj):
        return obj.enterprise_id.elroi_id

    class Meta:
        model = EnterpriseConfigurationModel
        fields = "__all__"


class EnterpriseAccountSettingsSerializer(serializers.ModelSerializer):
    elroi_id = serializers.CharField(read_only=True)
    logo = serializers.FileField(required=False)
    site_color = serializers.JSONField(required=False)
    second_color = serializers.JSONField(required=False)
    notification_email = serializers.EmailField(required=False)
    additional_emails = serializers.CharField(required=False)
    address = serializers.CharField(required=False)
    company_name = serializers.CharField(required=False)
    timezone = serializers.CharField(required=False)
    time_frame = serializers.CharField(required=False)

    # logo_url = serializers.SerializerMethodField(required=False)

    # def get_logo_url(self, obj):
    #     request = self.context.get("request")
    #     try:
    #         if obj.logo.url:
    #             return request.build_absolute_uri(obj.logo.url)
    #         else:
    #             return obj.logo
    #     except:
    #         return None

    class Meta:
        model = Enterprise
        fields = [
            "elroi_id",
            "logo",
            # "logo_url",
            "site_color",
            "second_color",
            "notification_email",
            "additional_emails",
            "address",
            "company_name",
            "timezone",
            "time_frame"
        ]


class EnterpriseEmailTemplateSerializer(serializers.ModelSerializer):

    confirm_request = serializers.CharField(required=False)
    update_extension = serializers.CharField(required=False)
    reject_request = serializers.CharField(required=False)
    accept_request = serializers.CharField(required=False)
    disposal_completed = serializers.CharField(required=False)
    data_modified = serializers.CharField(required=False)
    data_returned = serializers.CharField(required=False)

    class Meta:
        model = EnterpriseEmailTemplateModel
        fields = [
            "confirm_request",
            "update_extension",
            "reject_request",
            "accept_request",
            "disposal_completed",
            "data_modified",
            "data_returned",
        ]


class EnterpriseInviteSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(min_length=6, max_length=80, required=True)

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
