import os

from rest_framework import serializers

from api.v1.accounts.models import Enterprise
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import UserGuideModel, CustomerConfiguration, EnterpriseConfigurationModel, \
    UserGuideUploads


class UserGuideSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserGuideModel
        fields = '__all__'


class FileSerializer(serializers.ModelSerializer):
    file = serializers.FileField(read_only=True)
    name = serializers.CharField(max_length=255, read_only=True)
    size = serializers.IntegerField(read_only=True)

    class Meta:
        model = UserGuideUploads
        fields = ['file', 'name', 'size']


class CustomerConfigurationSerializer(serializers.ModelSerializer):
    elroi_id = serializers.SerializerMethodField()

    def get_elroi_id(self, obj):
        return obj.author.elroi_id

    class Meta:
        model = CustomerConfiguration
        fields = '__all__'


class CustomerSummarizeSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(required=True)

    class Meta:
        model = ConsumerRequest
        exclude = ['enterprise']


class RequestTrackerSerializer(serializers.ModelSerializer):
    elroi_id = serializers.CharField(required=True)

    class Meta:
        model = ConsumerRequest
        fields = ('status', 'request_date', 'process_end_date', 'elroi_id', 'remaining_days')


class EnterpriseConfigurationSerializer(serializers.ModelSerializer):
    elroi_id = serializers.SerializerMethodField()
    logo = serializers.SerializerMethodField()
    background_image = serializers.SerializerMethodField()

    def get_logo(self, obj):
        return obj.logo.url

    def get_background_image(self, obj):
        return obj.background_image.url

    def get_elroi_id(self, obj):
        return obj.enterprise_id.elroi_id

    class Meta:
        model = EnterpriseConfigurationModel
        fields = '__all__'

class EnterpriseAccountSettingsSerializer(serializers.ModelSerializer):
    elroi_id = serializers.CharField(read_only=True)
    logo = serializers.FileField()
    site_color = serializers.JSONField()
    second_color = serializers.JSONField()
    notification_email = serializers.EmailField()
    additional_emails = serializers.CharField()
    address = serializers.CharField()
    company_name = serializers.CharField()
    timezone = serializers.CharField()

    class Meta:
        model = Enterprise
        fields = ['elroi_id', 'logo', 'site_color','second_color', 'notification_email', 'additional_emails', 'address', 'company_name', 'timezone']
