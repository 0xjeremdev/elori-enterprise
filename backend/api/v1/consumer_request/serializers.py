from django.conf import settings
from datetime import datetime, timedelta
from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed, ValidationError
from rest_framework import serializers, status
from api.v1.consumer_request.models import ConsumerRequest, ConsumerReqeustQuestionModel
from api.v1.enterprise.models import Enterprise, EnterpriseQuestionModel
from ..enterprise.models import EnterpriseEmailType
from .utils import validate_filename, validate_filesize


class ConsumerRequestSerializer(serializers.ModelSerializer):
    status_text = serializers.SerializerMethodField()
    # request_type_text = serializers.SerializerMethodField()
    # elroi_id = serializers.SerializerMethodField()

    enterprise_id = serializers.IntegerField(read_only=True)
    web_id = serializers.CharField(read_only=True)
    email = serializers.CharField(required=True)
    first_name = serializers.CharField(required=False)
    last_name = serializers.CharField(required=False)
    timeframe = serializers.IntegerField(required=True)  # 0: GDPR, 1: CCPA
    state_resident = serializers.JSONField(required=False)
    request_type = serializers.CharField(required=False)
    additional_fields = serializers.JSONField(required=False)
    file = serializers.FileField(required=False)

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

    def validate(self, data):
        request = self.context.get("request")
        if not validate_filename(request.FILES.get("file")):
            raise Exception("Invalid filetype")
        if not validate_filesize(request.FILES.get("file")):
            raise Exception(
                "Too large filesize. The file should be less than 3MB.")
        return super().validate(data)

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


class ConsumerRequestQuestionSerializer(serializers.ModelSerializer):
    question_id = serializers.IntegerField(required=True)
    request_id = serializers.IntegerField(required=True)
    text_answer = serializers.CharField(required=False)
    boolean_answer = serializers.BooleanField(required=False)
    file_answer = serializers.FileField(required=False)

    class Meta:
        model = ConsumerReqeustQuestionModel
        fields = "__all__"
        # exclude = ["enterprise"]

    def validate(self, data):
        question = EnterpriseQuestionModel.objects.filter(
            id=data.get("question_id")).first()
        if question == None:
            raise Exception("Invalid Question ID")
        consumer_request = ConsumerRequest.objects.filter(
            id=data.get("request_id")).first()
        if consumer_request == None:
            raise Exception("Invalid Request ID")
        if consumer_request.enterprise != question.enterprise:
            raise Exception("Question and Request doesn't match")
        return super().validate(data)

    def create(self, validated_data):
        request = self.context.get("request")
        question = EnterpriseQuestionModel.objects.get(
            id=request.data.get("question_id"))
        consumer_request = ConsumerRequest.objects.get(
            id=request.data.get("request_id"))
        del validated_data["question_id"]
        del validated_data["request_id"]
        consumer_question = ConsumerReqeustQuestionModel.objects.create(
            consumer_request=consumer_request,
            question=question,
            **validated_data)
        print(consumer_question)
        return consumer_question


class ConsumerRequestSendSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    attachment = serializers.FileField(required=False)
    email_type = serializers.CharField(default="")

    def validate(self, data):
        request = self.context.get("request")
        if not validate_filename(request.FILES.get("attachment")):
            raise Exception("Invalid filetype")
        if not validate_filesize(request.FILES.get("attachment")):
            raise Exception(
                "Too large filesize. The file should be less than 3MB.")
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
