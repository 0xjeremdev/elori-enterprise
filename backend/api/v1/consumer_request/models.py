import django
import secrets
from datetime import datetime, timedelta

from django.conf import settings
from django.db import models
from django.utils.timezone import utc
from django.db.models.signals import post_save
from api.v1.accounts.models import Account, Enterprise
from api.v1.consumer_request.utils import gen_random_id
from ..enterprise.models import EnterpriseQuestionModel
from ..upload.models import Files
from api.v1.accounts.utlis import generate_auth_code


class ConsumerRequest(models.Model):
    # elroi_id = models.CharField(max_length=14, blank=True, null=True)
    enterprise = models.ForeignKey(
        Enterprise,
        on_delete=models.CASCADE,
        related_name="enterprise",
        null=True,
        blank=True,
    )
    ###########
    file = models.ForeignKey(Files,
                             on_delete=models.SET_NULL,
                             related_name="file_request",
                             null=True,
                             blank=True)
    # data_return = models.ForeignKey(DataReturnModel,
    #                                 on_delete=models.SET_NULL,
    #                                 related_name="data_return_request",
    #                                 null=True,
    #                                 blank=True)
    email = models.CharField(verbose_name="Email",
                             max_length=60,
                             unique=False,
                             null=True,
                             blank=True)
    first_name = models.CharField(max_length=40, null=True)
    last_name = models.CharField(max_length=40, null=True)
    state_resident = models.JSONField(null=True, blank=True)
    timeframe = models.IntegerField(choices=settings.TIMEFRAME_TYPE,
                                    default=1)  # 1: CCPA, 0: GDPR
    ###############3
    additional_fields = models.JSONField(null=True, blank=True)
    request_type = models.CharField(max_length=40, null=True)
    is_data_subject_name = models.BooleanField(default=False)
    status = models.IntegerField(choices=settings.STATUSES, default=0)
    process_end_date = models.DateTimeField(blank=True, null=True)
    request_date = models.DateTimeField(blank=True,
                                        null=True,
                                        default=datetime.utcnow)
    approved_date = models.DateTimeField(blank=True, null=True)
    extend_requested_date = models.DateTimeField(blank=True, null=True)
    extend_requested_days = models.IntegerField(default=0)
    is_extended = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        # return self.elroi_id
        return self.email

    # def save(self, *args, **kwargs):
    #     # self.elroi_id = gen_random_id()
    #     if self.request_date:
    #         self.process_end_date = datetime.utcnow() + timedelta(days=45)
    #     super(ConsumerRequest, self).save(*args, **kwargs)

    def remaining_days(self):
        if self.process_end_date:
            current_time = datetime.utcnow().replace(tzinfo=utc)
            return abs(self.process_end_date - current_time).days

    class Meta:
        db_table = "consumer_requests"
        ordering = ["-created_at"]


class ConsumerReqeustQuestionModel(models.Model):
    consumer_request = models.ForeignKey(
        ConsumerRequest,
        on_delete=models.CASCADE,
        related_name="consumer_request",
        null=True,
        blank=True,
    )
    question = models.ForeignKey(
        EnterpriseQuestionModel,
        on_delete=models.CASCADE,
        related_name="request_question",
        null=True,
        blank=True,
    )
    text_answer = models.CharField(max_length=500, blank=True, null=True)
    boolean_answer = models.BooleanField(blank=True, null=True)
    file_answer = models.FileField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "consumer_request_questions"
        ordering = ["-created_at"]


class ConsumerReqeustCodeModel(models.Model):
    email = models.CharField(max_length=500, blank=False, null=False)
    enterprise = models.ForeignKey(
        Enterprise,
        on_delete=models.SET_NULL,
        related_name="request_code_enterprise",
        null=True,
        blank=True,
    )
    code = models.CharField(max_length=6, blank=False, null=False, default="")
    lifetime = models.DateTimeField(blank=False, null=False, auto_now=True)

    class Meta:
        db_table = "consumer_request_codes"


class DataReturnModel(models.Model):
    consumer_request = models.OneToOneField(ConsumerRequest,
                                            on_delete=models.SET_NULL,
                                            related_name="request_dataReturn",
                                            null=True,
                                            blank=True)
    file = models.ForeignKey(Files,
                             on_delete=models.SET_NULL,
                             related_name="file_dataReturn",
                             null=True,
                             blank=True)
    link_id = models.CharField(max_length=255,
                               null=True,
                               default="",
                               unique=True)
    code = models.CharField(max_length=6, blank=False, null=False, default="")
    downloaded = models.BooleanField(default=False)
    lifetime = models.DateTimeField(blank=False, null=False, auto_now=False)

    class Meta:
        db_table = "data_return"

    def __str__(self):
        return ""

    @classmethod
    def create(cls, consumer_request, file):
        file_obj = Files.create(file)
        life_time = datetime.utcnow() + timedelta(days=7)
        dataReturn_obj = cls(consumer_request=consumer_request,
                             file=file_obj,
                             code=generate_auth_code(),
                             lifetime=life_time)
        dataReturn_obj.save()
        return dataReturn_obj


def update_data_return_link_id(sender, instance, created, **kwargs):
    if created:
        token = generate_link_id()
        link_id = check_unique_data_return_link_id(token)
        instance.link_id = token
        instance.save()


""" check if link_id doesn't exists already """


def check_unique_data_return_link_id(check_id):
    try:
        DataReturnModel.objects.get(link_id__exact=check_id)
        link_id = generate_link_id()
        return check_unique_data_return_link_id(link_id)
    except DataReturnModel.DoesNotExist:
        return check_id


post_save.connect(update_data_return_link_id, sender=DataReturnModel)


def generate_link_id():
    token = secrets.token_hex(20)
    return f"{token}"