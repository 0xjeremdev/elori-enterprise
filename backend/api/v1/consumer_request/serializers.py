from django.conf import settings
from datetime import datetime, timedelta
from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed, ValidationError
from rest_framework import serializers, status
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import Enterprise
from ..enterprise.models import EnterpriseEmailType


class ConsumerRequestSerializer(serializers.ModelSerializer):
    status_text = serializers.SerializerMethodField()
    # request_type_text = serializers.SerializerMethodField()
    # elroi_id = serializers.SerializerMethodField()

    enterprise_id = serializers.IntegerField(read_only=True)
    email = serializers.CharField(required=True)
    first_name = serializers.CharField(required=False)
    last_name = serializers.CharField(required=False)
    timeframe = serializers.IntegerField(required=True)  # 0: GDPR, 1: CCPA
    state_resident = serializers.JSONField(required=False)
    request_type = serializers.CharField(required=False)
    file = serializers.FileField(required=False)
    additional_fields = serializers.JSONField(required=False)

    def get_elroi_id(self, obj):
        return obj.enterprise.elroi_id

    class Meta:
        model = ConsumerRequest
        # fields = "__all__"
        exclude = ["enterprise"]

    """ used to return text for statuses """

    def get_status_text(self, obj):
        return settings.STATUSES[obj.status][1]

    """ used to return text for request type """

    def create(self, validated_data):
        request = self.context.get("request")
        enterprise = Enterprise.objects.get(
            id=request.data.get("enterprise_id"))
        timeframe = request.data.get("timeframe")
        consumer_request = ConsumerRequest.objects.create(
            enterprise=enterprise,
            **validated_data,
            process_end_date=datetime.utcnow() +
            timedelta(days=30 if timeframe == 0 else 45))
        return consumer_request


class ConsumerRequestSendSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    attachment = serializers.FileField(required=False)
    email_type = serializers.CharField(default="")

    def validate(self, data):
        if not EnterpriseEmailType.objects.filter(
                type_name=data.get("email_type")).exists():
            raise Exception("Invalid EmailType")
        if not ConsumerRequest.objects.filter(pk=data.get("id")).exists():
            raise Exception("Invalid ConsumerRequest ID")
        return super().validate(data)


class ConsumerReportSerializer(serializers.ModelSerializer):
    status_text = serializers.SerializerMethodField()
    timeframe_text = serializers.SerializerMethodField()
    email = serializers.CharField()
    first_name = serializers.CharField()
    last_name = serializers.CharField()
    state_resident = serializers.JSONField()
    timeframe = serializers.IntegerField()
    status = serializers.IntegerField()
    request_type = serializers.CharField()
    request_date = serializers.DateTimeField()
    process_end_date = serializers.DateTimeField()
    approved_date = serializers.DateTimeField()
    extend_requested_date = serializers.DateTimeField()
    extend_requested_days = serializers.IntegerField()

    class Meta:
        model = ConsumerRequest
        exclude = [
            "enterprise", "id", "file", "is_data_subject_name", "is_extended",
            "created_at", "updated_at", "additional_fields"
        ]

    def get_list(self):
        values_list = []
        data = self.data
        data["status"] = settings.STATUSES[data["status"]][1]
        data["timeframe"] = settings.TIMEFRAME_TYPE[data["timeframe"]][1]
        for key in data.keys():
            values_list.append(data[key])
        return values_list


class PeriodParameterSerializer(serializers.Serializer):
    period = serializers.CharField(max_length=8,
                                   write_only=True,
                                   required=False)

    class Meta:
        fields = ["period"]
