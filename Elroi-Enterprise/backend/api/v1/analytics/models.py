from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models

from api.v1.accounts.models import Account
from api.v1.analytics.signals import object_viewed_signal

class Analytics(models.Model):
    user = models.ForeignKey(Account, on_delete=models.CASCADE)
    content_type = models.ForeignKey(ContentType, null=True, on_delete=models.SET_NULL)
    object_id = models.GenericIPAddressField()
    content_object = GenericForeignKey('content_type', 'object_id')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.content_object} viewed: {self.created_at}"

    class Meta:
        ordering = ['-created_at']


def object_viewed_receiver(sender, instance, request, *args, **kwargs):
    new_history = Analytics.objects.create(
        user=request.user,
        content_type=ContentType.objects.get_for_model(sender),
        object_id=instance.id,
    )


object_viewed_signal.connect(object_viewed_receiver)


class PrefetchUserManager(models.Manager):
    def get_queryset(self):
        return super(PrefetchUserManager, self).get_queryset().select_related('user')

class ActivityLog(models.Model):
    user = models.ForeignKey(Account, on_delete=models.SET_NULL, null=True, blank=True, related_name="user_logs")
    username_persistent = models.CharField(max_length=200, null=True, blank=True)
    requested_at = models.DateTimeField(db_index=True)
    response_ms = models.PositiveIntegerField(default=0)
    elroi_id = models.CharField(max_length=9)
    path = models.CharField(max_length=255, db_index=True, help_text='url path')
    view = models.CharField(max_length=255, null=True, blank=True, db_index=True, help_text="method called by endpoint")
    view_method = models.CharField(max_length=255, null=True, blank=True, db_index=True)
    remote_addr = models.GenericIPAddressField()
    host = models.URLField()
    method = models.CharField(max_length=10)
    query_params = models.TextField(null=True, blank=True)
    data = models.TextField(null=True, blank=True)
    response = models.TextField(null=True, blank=True)
    errors = models.TextField(null=True, blank=True)
    status_code = models.PositiveIntegerField(null=True, blank=True)
    objects = PrefetchUserManager()

    class Meta:
        verbose_name = "Api logs"
        ordering = ['-requested_at']

    def __str__(self):
        return f'{self.method} {self.path}'
