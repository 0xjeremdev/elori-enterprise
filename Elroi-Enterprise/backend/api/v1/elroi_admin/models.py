from django.db import models

from api.v1.accounts.models import Account


class AdminEnterpriseConfig(models.Model):
    name = models.CharField(max_length=255)
    key = models.CharField(max_length=255, unique=True)
    value = models.CharField(max_length=255)
    created_by = models.ForeignKey(Account, related_name='author', on_delete=models.SET_NULL, null=True, blank=True)
    updated_by = models.ForeignKey(Account, related_name='editor', on_delete=models.SET_NULL, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'admin_enterprise_config'
        ordering = ['-created_at']

