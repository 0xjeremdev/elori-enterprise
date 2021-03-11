import secrets
from datetime import datetime

from django.contrib.auth.models import BaseUserManager, AbstractUser
from django.db import models
from django.db.models.signals import post_save
from rest_framework_simplejwt.tokens import RefreshToken
from ..upload.models import Files


class CustomAccountManager(BaseUserManager):
    def create_front_user(self, email, username, password):
        user = self.model(
            email=self.normalize_email(email),
            username=username,
            is_active=True,
        )
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, email, username, password=None):
        if not email:
            raise ValueError("Please provide an email address")
        if not username:
            raise ValueError("Please provide an username")

        user = self.model(
            email=self.normalize_email(email),
            username=username,
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, username, password):
        user = self.model(
            email=self.normalize_email(email),
            username=username,
            is_active=True,
            is_admin=True,
            is_staff=True,
            is_superuser=True,
        )
        user.set_password(password)
        user.save(using=self._db)
        return user


class Account(AbstractUser):
    email = models.CharField(verbose_name="Email", max_length=60, unique=True)
    username = models.CharField(verbose_name="Username",
                                max_length=60,
                                unique=True)
    elroi_id = models.CharField(max_length=9,
                                db_index=True,
                                unique=True,
                                blank=True,
                                null=True)
    verification_code = models.CharField(max_length=6, blank=True, null=True)
    logo = models.ForeignKey(Files,
                             on_delete=models.SET_NULL,
                             related_name="account_logo",
                             null=True,
                             blank=True)
    first_name = models.CharField(max_length=80, null=True, blank=True)
    last_name = models.CharField(max_length=80, null=True, blank=True)
    phone_number = models.CharField(max_length=20, null=True, blank=True)
    timezone = models.CharField(max_length=20, null=True, blank=True)
    otp_verified = models.BooleanField(default=False)
    login_failed = models.IntegerField(default=0)
    is_2fa_active = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)
    is_active = models.BooleanField(default=False)
    is_verified = models.BooleanField(default=False)
    is_banned = models.BooleanField(default=False)
    is_member = models.BooleanField(default=False)
    is_enterprise = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    is_locked = models.BooleanField(default=False)
    last_login = models.DateTimeField(auto_now=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # USERNAME_FIELD = "username"
    # REQUIRED_FIELDS = []

    objects = CustomAccountManager()

    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}"

    def profile(self):
        return "Account"

    def is_2fa_on(self):
        if self.verification_code is not None and self.otp_verified:
            return True
        else:
            return False

    def __str__(self):
        return self.email

    def has_perm(self, perm, obj=None):
        return self.is_admin

    def has_module_perms(self, app_label):
        return True

    def tokens(self):
        refresh = RefreshToken.for_user(self)
        return {"refresh": str(refresh), "access": str(refresh.access_token)}

    """ get user's full name"""

    def full_name(self):
        return f"{self.first_name} {self.last_name}"


""" update elroi id for enterprises"""


def update_elroi_id(sender, instance, created, **kwargs):
    if created:
        token = generate_id(prefix="E")
        elroi_id = check_unique_elroi_id(token)
        instance.elroi_id = elroi_id
        instance.save()


""" check if elroi_id doesn't exists already """


def check_unique_elroi_id(check_id):
    try:
        Account.objects.get(elroi_id__exact=check_id)
        elroi_id = generate_id("E")
        return check_unique_elroi_id(elroi_id)
    except Account.DoesNotExist:
        return check_id


post_save.connect(update_elroi_id, sender=Account)


def generate_id(prefix="C"):
    token = secrets.token_hex(3).upper()
    return f"{prefix}-{token}"


""" enterprises table """


class Enterprise(models.Model):
    user = models.OneToOneField(
        Account,
        related_name="enterprise",
        on_delete=models.CASCADE,
        blank=True,
        null=True,
    )
    notification_email = models.CharField(max_length=80, null=True, blank=True)
    additional_emails = models.CharField(max_length=255, null=True, blank=True)
    company_name = models.CharField(max_length=80, null=True, blank=True)
    timezone = models.CharField(max_length=20, null=True, blank=True)
    address = models.CharField(max_length=255, null=True, blank=True)
    logo = models.ForeignKey(Files,
                             on_delete=models.SET_NULL,
                             related_name="enterprise_logo",
                             null=True,
                             blank=True)
    time_frame = models.CharField(max_length=255,
                                  null=True,
                                  blank=True,
                                  default="both")
    is_active = models.BooleanField(default=True)
    updated_by = models.ForeignKey(
        Account,
        related_name="updated_by",
        on_delete=models.CASCADE,
        blank=True,
        null=True,
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.user.elroi_id

    def profile(self):
        return "Enterprise"

    def full_name(self):
        return f"{self.user.first_name} {self.user.last_name}"

    """ get current subscription type """

    def current_subscription(self):
        if self.trial_end <= datetime.now():
            return "trial"

        if self.current_plan_end >= datetime.now():
            return "subscribed"

        return "expired"

    class Meta:
        db_table = "enterprises"
        ordering = ["-created_at"]


class Staff(models.Model):
    user = models.OneToOneField(
        Account,
        related_name="staff",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
    )
    enterprise = models.OneToOneField(
        Enterprise,
        related_name="staff",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.elroi_id

    def profile(self):
        return "Staff"

    def full_name(self):
        return f"{self.user.first_name} {self.user.last_name}"

    class Meta:
        db_table = "staffs"
