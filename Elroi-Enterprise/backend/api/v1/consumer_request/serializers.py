from django.conf import settings
from rest_framework import serializers

from api.v1.consumer_request.models import ConsumerRequest


class ConsumerRequestSerializer(serializers.ModelSerializer):
    status_text = serializers.SerializerMethodField()
    request_type_text = serializers.SerializerMethodField()
    elroi_id = serializers.SerializerMethodField()

    def get_elroi_id(self, obj):
        return obj.enterprise.elroi_id

    class Meta:
        model = ConsumerRequest
        exclude = ['enterprise']

    """ used to return text for statuses """

    def get_status_text(self, obj):
        return settings.STATUSES[obj.status][1]

    """ used to return text for request type """

    def get_request_type_text(self, obj):
        return settings.REQUEST_TYPES[obj.request_type][1]


class PeriodParameterSerializer(serializers.Serializer):
    period = serializers.CharField(max_length=8, write_only=True, required=False)

    class Meta:
        fields = ['period']