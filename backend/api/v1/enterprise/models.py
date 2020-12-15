import uuid
from django.contrib.postgres.fields import JSONField
from django.db import models

from api.v1.accounts.models import Account, Enterprise


class UserGuideModel(models.Model):
    enterprise = models.ForeignKey(Enterprise,
                                   on_delete=models.SET_NULL,
                                   null=True,
                                   blank=True)
    elroi_id = models.CharField(
        max_length=9,
        null=True,
        blank=True,
    )
    title = models.CharField(max_length=255, blank=True, null=True)
    content = models.TextField(null=True, blank=True)
    created_by = models.ForeignKey(Account,
                                   on_delete=models.SET_NULL,
                                   null=True,
                                   blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return "User guide Model"

    def save(self, *args, **kwargs):
        if self.enterprise:
            self.elroi_id = self.enterprise.elroi_id
        if not self.enterprise and self.elroi_id:
            self.enterprise = Enterprise.objects.get(
                elroi_id__exact=self.elroi_id)
        super(UserGuideModel, self).save(*args, **kwargs)

    class Meta:
        db_table = "user_guide"
        ordering = ["-created_at"]


class UserGuideUploads(models.Model):
    user_guide = models.ForeignKey(
        UserGuideModel,
        related_name="uploads",
        related_query_name="uploads",
        on_delete=models.CASCADE,
    )
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
        db_table = "user_guide_uploads"
        ordering = ["-created_at"]
        default_related_name = "uploads"


class CustomerConfiguration(models.Model):
    title = models.CharField(max_length=255)
    author = models.ForeignKey(Enterprise, on_delete=models.CASCADE)
    config = models.JSONField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = "enterprise_customer_configuration"
        ordering = ["-created_at"]


class EnterpriseConfigurationModel(models.Model):
    enterprise_id = models.ForeignKey(Enterprise,
                                      related_name="configuration",
                                      on_delete=models.CASCADE)
    logo = models.FileField()
    site_color = models.JSONField(null=True, blank=True)
    site_theme = models.JSONField(null=True, blank=True)
    background_image = models.FileField()
    website_launched_to = models.CharField(max_length=255)
    company_name = models.CharField(max_length=255)
    resident_state = models.BooleanField(default=True)
    additional_configuration = models.JSONField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.company_name

    class Meta:
        db_table = "enterprise_configuration"
        ordering = ["-created_at"]


class EnterpriseInviteModel(models.Model):
    invite_key = models.UUIDField(default=uuid.uuid4, editable=False)
    enterprise = models.ForeignKey(Enterprise, on_delete=models.CASCADE)
    email = models.EmailField(verbose_name="Email", max_length=60)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.email

    class Meta:
        db_table = "enterprise_invite"
        ordering = ["-created_at"]
