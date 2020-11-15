from django.conf import settings
from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed, ValidationError
from rest_framework import serializers, status
from api.v1.consumer_request.models import ConsumerRequest
from api.v1.enterprise.models import Enterprise


class ConsumerRequestSerializer(serializers.ModelSerializer):
    status_text = serializers.SerializerMethodField()
    # request_type_text = serializers.SerializerMethodField()
    # elroi_id = serializers.SerializerMethodField()

    enterprise_id = serializers.IntegerField(read_only=True)
    email = serializers.CharField(required=True)
    first_name = serializers.CharField(required=False)
    last_name = serializers.CharField(required=False)
    state_resident = serializers.BooleanField(required=False)
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
        consumer_request = ConsumerRequest.objects.create(
            enterprise=enterprise, **validated_data)
        return consumer_request


class PeriodParameterSerializer(serializers.Serializer):
    period = serializers.CharField(max_length=8,
                                   write_only=True,
                                   required=False)

    class Meta:
        fields = ["period"]
