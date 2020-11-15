import django

from datetime import datetime, timedelta

from django.conf import settings
from django.db import models
from django.utils.timezone import utc

from api.v1.accounts.models import Account, Enterprise, Customer
from api.v1.consumer_request.utils import gen_random_id


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
    file = models.FileField(blank=True, null=True)
    email = models.EmailField(verbose_name="Email",
                              max_length=60,
                              unique=False,
                              null=True,
                              blank=True)
    first_name = models.CharField(max_length=40, null=True)
    last_name = models.CharField(max_length=40, null=True)
    state_resident = models.BooleanField(default=False)
    additional_fields = models.JSONField(null=True, blank=True)
    ###############3
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
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        # return self.elroi_id
        return self.email

    def save(self, *args, **kwargs):
        self.elroi_id = gen_random_id()
        if self.request_date:
            self.process_end_date = datetime.utcnow() + timedelta(days=45)
        super(ConsumerRequest, self).save(*args, **kwargs)

    def remaining_days(self):
        if self.process_end_date:
            current_time = datetime.utcnow().replace(tzinfo=utc)
            return abs(self.process_end_date - current_time).days

    class Meta:
        db_table = "consumer_requests"
        ordering = ["-created_at"]
