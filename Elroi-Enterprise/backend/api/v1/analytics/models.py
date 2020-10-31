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
