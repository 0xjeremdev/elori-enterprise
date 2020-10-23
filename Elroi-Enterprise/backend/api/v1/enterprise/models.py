from django.contrib.postgres.fields import JSONField
from django.db import models

from api.v1.accounts.models import Account


class UserGuide(models.Model):
    title = models.CharField(max_length=255, blank=True, null=True)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'user_guide'
        ordering = ['-created_at']


class CustomerConfiguration(models.Model):
    title = models.CharField(max_length=255)
    author = models.ForeignKey(Account, on_delete=models.CASCADE)
    config = JSONField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'enterprise_customer_configuration'
        ordering = ['-created_at']


class EnterpriseConfigurationModel(models.Model):
    title = models.CharField(max_length=255)
    enterprise = models.ForeignKey(Account, on_delete=models.CASCADE)
    configuration = JSONField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'enterprise_configuration'
        ordering = ['-created_at']
