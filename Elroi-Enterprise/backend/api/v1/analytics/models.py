from django.db import models

from api.v1.accounts.models import Account

class PrefetchUserManager(models.Manager):
    def get_queryset(self):
        return super(PrefetchUserManager, self).get_queryset().select_related('user')

class ActivityLog(models.Model):
    """
    Model used to store all user's activity
    """
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
