import django

from datetime import datetime, timedelta

from django.conf import settings
from django.db import models
from django.utils.timezone import utc

from api.v1.accounts.models import Account, Enterprise, Customer
from api.v1.consumer_request.utils import gen_random_id
from django.contrib.postgres.fields import JSONField

class ConsumerRequest(models.Model):
    elroi_id = models.CharField(max_length=14, blank=True, null=True)
    title = models.CharField(blank=True, null=True, max_length=255)
    enterprise = models.ForeignKey(Enterprise, on_delete=models.CASCADE, related_name='enterprise', null=True, blank=True)
    customer = models.ForeignKey(Customer, related_name='customer', on_delete=models.CASCADE, null=True, blank=True)
    request_type = models.IntegerField(choices=settings.REQUEST_TYPES, default=0)
    description = models.TextField(blank=True, null=True)
    request_form = JSONField(blank=True, null=True)
    is_data_subject_name = models.BooleanField(default=False)
    status = models.IntegerField(choices=settings.STATUSES, default=0)
    process_end_date = models.DateTimeField(blank=True, null=True)
    request_date = models.DateTimeField(blank=True, null=True, default=datetime.now)
    approved_date = models.DateTimeField(blank=True, null=True)
    extend_requested = models.BooleanField(default=False)
    extend_requested_date = models.DateTimeField(blank=True, null=True)
    extend_requested_days = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.elroi_id

    def save(self, *args, **kwargs):
        self.elroi_id = gen_random_id()
        if self.request_date:
            self.process_end_date = datetime.now()+timedelta(days=45)
        super(ConsumerRequest, self).save(*args, **kwargs)

    def remaining_days(self):
        if self.process_end_date:
            current_time = datetime.utcnow().replace(tzinfo=utc)
            return abs(self.process_end_date - current_time).days


    class Meta:
        db_table = 'consumer_requests'
        ordering = ['-created_at']
