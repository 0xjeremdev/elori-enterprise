import secrets
from datetime import datetime

from django.contrib.auth.models import BaseUserManager, AbstractUser
from django.db import models
from django.db.models.signals import post_save
from rest_framework_simplejwt.tokens import RefreshToken


class CustomAccountManager(BaseUserManager):
    def create_front_user(self, email, password):
        user = self.model(
            email=self.normalize_email(email),
            username=self.normalize_email(email),
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

    def create_superuser(self, email, password):
        user = self.model(
            email=self.normalize_email(email),
            username=self.normalize_email(email),
            is_active=True,
            is_admin=True,
            is_staff=True,
            is_superuser=True,
        )
        user.set_password(password)
        user.save(using=self._db)
        return user


class Account(AbstractUser):
    email = models.EmailField(verbose_name="Email", max_length=60, unique=True)
    verification_code = models.CharField(max_length=6, blank=True, null=True)
    logo = models.FileField(null=True, blank=True)
    first_name = models.CharField(max_length=80, null=True, blank=True)
    last_name = models.CharField(max_length=80, null=True, blank=True)
    company_email = models.EmailField(max_length=60, null=True, blank=True)
    phone_number = models.CharField(max_length=20, null=True, blank=True)
    company_name = models.CharField(max_length=255, null=True, blank=True)
    timezone = models.CharField(max_length=20, null=True, blank=True)
    otp_verified = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)
    is_active = models.BooleanField(default=False)
    is_verified = models.BooleanField(default=False)
    is_banned = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    last_login = models.DateTimeField(auto_now=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    objects = CustomAccountManager()

    @property
    def elroi_id(self):
        return "Account"

    def full_name(self):
        return "Account"

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


""" enterprises table """


class Enterprise(models.Model):
    user = models.OneToOneField(
        Account,
        related_name="enterprise",
        on_delete=models.CASCADE,
        blank=True,
        null=True,
    )
    elroi_id = models.CharField(max_length=9,
                                db_index=True,
                                unique=True,
                                blank=True,
                                null=True)
    email = models.EmailField(max_length=80, unique=True)
    name = models.CharField(max_length=255, blank=True, null=True)
    notification_email = models.EmailField(max_length=80,
                                           null=True,
                                           blank=True)
    additional_emails = models.CharField(max_length=255, null=True, blank=True)
    company_name = models.CharField(max_length=80, null=True, blank=True)
    timezone = models.CharField(max_length=20, null=True, blank=True)
    address = models.CharField(max_length=255, null=True, blank=True)
    logo = models.FileField(null=True, blank=True)
    site_color = models.JSONField(null=True, blank=True)
    second_color = models.JSONField(null=True, blank=True)
    first_name = models.CharField(max_length=40, null=True)
    last_name = models.CharField(max_length=40, null=True)
    web = models.CharField(max_length=255, blank=True, null=True)
    trial_start = models.DateTimeField(blank=True, null=True)
    trial_end = models.DateTimeField(blank=True, null=True)
    current_plan_end = models.DateTimeField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    turn_off_date = models.DateTimeField(blank=True, null=True)
    allow_email_data = models.BooleanField(default=True)
    allow_api_call = models.BooleanField(default=True)
    payment = models.JSONField(null=True, blank=True)
    updated_by = models.ForeignKey(
        Account,
        related_name="updated_by",
        on_delete=models.CASCADE,
        blank=True,
        null=True,
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.elroi_id

    def profile(self):
        return "Enterprise"

    def full_name(self):
        return f"{self.first_name} {self.last_name}"

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


""" update elroi id for enterprises"""


def update_enterprise_elroi_id(sender, instance, created, **kwargs):
    if created:
        token = generate_id(prefix="E")
        elroi_id = check_unique_enterprise_elroi_id(token)
        instance.elroi_id = elroi_id
        instance.save()


""" check if elroi_id doesn't exists already """


def check_unique_enterprise_elroi_id(check_id):
    try:
        Enterprise.objects.get(elroi_id__exact=check_id)
        elroi_id = generate_id("E")
        return check_unique_enterprise_elroi_id(elroi_id)
    except Enterprise.DoesNotExist:
        return check_id


post_save.connect(update_enterprise_elroi_id, sender=Enterprise)
"""generate random id ( characters+ digits)"""

"------------------------------------------------------------------"
""" customers table """


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
    elroi_id = models.CharField(max_length=9,
                                db_index=True,
                                unique=True,
                                null=True,
                                blank=True)
    email = models.EmailField(verbose_name="Email",
                              max_length=60,
                              unique=True,
                              null=True,
                              blank=True)
    first_name = models.CharField(max_length=40, null=True)
    last_name = models.CharField(max_length=40, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.elroi_id

    def profile(self):
        return "Staff"

    def full_name(self):
        return f"{self.first_name} {self.last_name}"

    class Meta:
        db_table = "staffs"


""" method used to update elroi_id when new user is created """


def update_staff_elroi_id(sender, instance, created, **kwargs):
    if created:
        token = generate_id(prefix="E")
        elroi_id = check_unique_staff_elroi_id(token)
        instance.elroi_id = elroi_id
        instance.save()


""" check and generate unique elroi_id"""


def check_unique_staff_elroi_id(elroi_id):
    try:
        Staff.objects.get(elroi_id__exact=elroi_id)
        elroi_id = generate_id(prefix="E")
        return check_unique_staff_elroi_id(elroi_id)
    except Staff.DoesNotExist:
        return elroi_id


"""call signal to update elroi id when account is created"""
post_save.connect(update_staff_elroi_id, sender=Staff)


def generate_id(prefix="C"):
    token = secrets.token_hex(3).upper()
    return f"{prefix}-{token}"
