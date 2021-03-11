import uuid
import secrets
from django.contrib.postgres.fields import JSONField
from django.db import models
from django.conf import settings
from django.db.models.signals import post_save
from api.v1.accounts.models import Account, Enterprise
from ..upload.models import Files


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
    file = models.ForeignKey(Files,
                             on_delete=models.SET_NULL,
                             related_name="user_guide_file",
                             null=True,
                             blank=True)
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


class EnterpriseEmailType(models.Model):
    email_id = models.IntegerField(primary_key=True)
    email_type = models.CharField(max_length=255)
    type_name = models.CharField(max_length=255, default="")

    class Meta:
        db_table = "enterprise_email_type"


class EnterpriseEmailTemplateModel(models.Model):
    enterprise = models.ForeignKey(Enterprise,
                                   related_name="enterprise_email_template",
                                   on_delete=models.CASCADE)
    email_type = models.ForeignKey(EnterpriseEmailType,
                                   related_name="email_type_content",
                                   on_delete=models.CASCADE)
    content = models.TextField(null=True, blank=True, default="")
    attachment = models.ForeignKey(Files,
                                   on_delete=models.SET_NULL,
                                   related_name="email_temp_attachment",
                                   null=True,
                                   blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.enterprise

    class Meta:
        db_table = "enterprise_email_template"
        ordering = ["-created_at"]


class EnterpriseConfigurationModel(models.Model):
    enterprise_id = models.ForeignKey(Enterprise,
                                      related_name="configuration",
                                      on_delete=models.CASCADE)
    logo = models.ForeignKey(Files,
                             on_delete=models.SET_NULL,
                             related_name="enterprise_conf_logo",
                             null=True,
                             blank=True)
    site_color = models.JSONField(null=True, blank=True)
    site_theme = models.JSONField(null=True, blank=True)
    background_image = models.ForeignKey(
        Files,
        on_delete=models.SET_NULL,
        related_name="enterprise_conf_background",
        null=True,
        blank=True)
    privacy_description = models.TextField(null=True, blank=True, default="")
    file_description = models.TextField(null=True, blank=True, default="")
    website_launched_to = models.CharField(
        max_length=255,
        null=True,
        default="",
    )
    resident_state = models.BooleanField(default=False)
    additional_configuration = models.JSONField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.enterprise_id.company_name

    class Meta:
        db_table = "enterprise_configuration"
        ordering = ["-created_at"]


""" update elroi id for enterprises"""


def update_enterprise_web_id(sender, instance, created, **kwargs):
    if created:
        token = generate_web_id()
        web_id = check_unique_enterprise_web_id(token)
        instance.website_launched_to = web_id
        instance.save()
    elif instance.website_launched_to == '':
        token = generate_web_id()
        web_id = check_unique_enterprise_web_id(token)
        instance.website_launched_to = web_id
        instance.save()


""" check if elroi_id doesn't exists already """


def check_unique_enterprise_web_id(check_id):
    try:
        EnterpriseConfigurationModel.objects.get(
            website_launched_to__exact=check_id)
        web_id = generate_web_id()
        return check_unique_enterprise_web_id(web_id)
    except EnterpriseConfigurationModel.DoesNotExist:
        return check_id


post_save.connect(update_enterprise_web_id,
                  sender=EnterpriseConfigurationModel)


def generate_web_id():
    token = secrets.token_hex(16)
    return f"{token}"


class EnterpriseQuestionModel(models.Model):
    enterprise = models.ForeignKey(Enterprise,
                                   related_name="question",
                                   on_delete=models.CASCADE)
    content = models.CharField(max_length=500, blank=False, null=False)
    question_type = models.IntegerField(
        choices=settings.QUESTION_TYPES,
        default=0)  # 0: Text, 1: Yes/No, 2: File
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "enterprise_questions"
        ordering = ["-created_at"]


class EnterpriseInviteModel(models.Model):
    invite_key = models.UUIDField(default=uuid.uuid4, editable=False)
    enterprise = models.ForeignKey(Enterprise, on_delete=models.CASCADE)
    email = models.CharField(verbose_name="Email", max_length=60)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.email

    class Meta:
        db_table = "enterprise_invite"
        ordering = ["-created_at"]
