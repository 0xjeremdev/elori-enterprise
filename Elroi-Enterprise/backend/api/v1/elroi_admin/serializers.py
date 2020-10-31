from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from api.v1.accounts.models import Enterprise
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.elroi_admin.models import AdminEnterpriseConfig


class EnterpriseTrialSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdminEnterpriseConfig
        fields = '__all__'

    def create(self, validated_data):
        enterprise_config = AdminEnterpriseConfig.objects.create(
            name=validated_data['name'],
            key=validated_data['key'],
            value=validated_data['value'],
            created_by=validated_data['created_by'],
            updated_by=validated_data['updated_by']
        )
        return enterprise_config


class EnterpriseMaintenanceSerializer(serializers.ModelSerializer):
    """ Serializer used to manage the status of specific enterprise """
    elroi_id = serializers.CharField(max_length=9, read_only=True)
    is_active = serializers.BooleanField(required=True)
    turn_off_date = serializers.DateTimeField(required=True)
    trial_start = serializers.DateTimeField(required=False)
    trial_end = serializers.DateTimeField(required=False)

    class Meta:
        model = Enterprise
        fields = ('elroi_id', 'is_active', 'turn_off_date', 'trial_start', 'trial_end')

class EnterprisePaymentSerializer(serializers.ModelSerializer):
    payment = serializers.JSONField()

    class Meta:
        model = Enterprise
        exclude = ['email']
        read_only_fields = ['elroi_id']


class EnterpriseCustomersSerializer(serializers.ModelSerializer):
    unique_customers = serializers.SerializerMethodField('get_tied_customers')
    total_requests = serializers.SerializerMethodField('get_total_requests')

    def get_total_requests(self, obj):
        req_total = ConsumerRequest.objects.filter(enterprise=obj.id).count()
        return req_total

    def get_tied_customers(self, obj):
        total_customers = ConsumerRequest.objects.filter(enterprise=obj.id).distinct('customer_id').order_by('customer_id').count()
        return total_customers

    class Meta:
        model = Enterprise
        fields = ('elroi_id', 'unique_customers', 'total_requests', 'name')
        read_only_fields = ['elroi_id']
