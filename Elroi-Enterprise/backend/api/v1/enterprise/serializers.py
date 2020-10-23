from rest_framework import serializers

from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import UserGuide, CustomerConfiguration, EnterpriseConfigurationModel


class UserGuideSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserGuide
        fields = '__all__'


class CustomerConfigurationSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomerConfiguration
        fields = '__all__'


class CustomerSummarizeSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(required=True)

    class Meta:
        model = ConsumerRequest
        fields = '__all__'


class RequestTrackerSerializer(serializers.ModelSerializer):
    elroi_id = serializers.CharField(required=True)

    class Meta:
        model = ConsumerRequest
        fields = ('status', 'request_date', 'process_end_date', 'elroi_id', 'remaining_days')


class EnterpriseConfigurationSerializer(serializers.ModelSerializer):
    class Meta:
        model = EnterpriseConfigurationModel
        fields = '__all__'
