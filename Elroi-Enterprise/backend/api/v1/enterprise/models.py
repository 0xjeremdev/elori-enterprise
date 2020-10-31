from django.contrib.postgres.fields import JSONField
from django.db import models

from api.v1.accounts.models import Account


class UserGuideModel(models.Model):
    title = models.CharField(max_length=255, blank=True, null=True)
    content = models.TextField()
    owner = models.ForeignKey(Account, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'user_guide'
        ordering = ['-created_at']

class UserGuideUploads(models.Model):
    user_guide = models.ForeignKey(UserGuideModel, related_name='uploads', related_query_name='uploads', on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    file = models.FileField(blank=False, null=False)
    size = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.file.name

    def save(self, *args, **kwargs):
        self.size = self.file.size
        self.name = self.file.name
        super(UserGuideUploads, self).save(*args, **kwargs)

    class Meta:
        db_table = 'user_guide_uploads'
        ordering = ['-created_at']
        default_related_name = 'uploads'


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
    enterprise = models.ForeignKey(Account, related_name='configuration',  on_delete=models.CASCADE)
    logo = models.FileField()
    site_color = models.CharField(max_length=7)
    site_theme = models.CharField(max_length=12)
    background_image = models.FileField()
    website_launched_to = models.CharField(max_length=255)
    company_name = models.CharField(max_length=255)
    resident_state = models.BooleanField(default=True)
    additional_configuration = JSONField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'enterprise_configuration'
        ordering = ['-created_at']
