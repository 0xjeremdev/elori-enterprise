import secrets
from datetime import datetime

import phonenumbers
from django.conf import settings
from django.contrib.auth.models import (BaseUserManager, AbstractUser)
from django.db import models
from django.db.models.signals import post_save
from phonenumber_field.modelfields import PhoneNumberField
from rest_framework_simplejwt.tokens import RefreshToken


class CustomAccountManager(BaseUserManager):
    def create_front_user(self, state_resident, first_name, last_name, email, password, account_type):
        user = self.model(
            username=self.normalize_email(email),
            state_resident=state_resident,
            email=self.normalize_email(email),
            first_name=first_name,
            last_name=last_name,
            account_type=account_type,
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
        user = self.create_user(
            email=self.normalize_email(email),
            username=username,
            password=password,
        )
        user.is_admin = True
        user.is_active = True
        user.is_superuser = True
        user.is_staff = True

        user.save(using=self._db)
        return user


class Account(AbstractUser):
    elroi_id = models.CharField(max_length=9, blank=True, null=True, db_index=True)
    email = models.EmailField(verbose_name="Email", max_length=60, unique=True)
    username = models.CharField(max_length=30, unique=True)
    first_name = models.CharField(max_length=40, null=True)
    last_name = models.CharField(max_length=40, null=True)
    state_resident = models.BooleanField(default=False)
    auth_phone = PhoneNumberField(null=True, blank=True, unique=True)
    auth_id = models.CharField(max_length=12, blank=True)
    verification_code = models.IntegerField(blank=True, null=True, default=0)
    otp_verified = models.BooleanField(default=False)
    account_type = models.IntegerField(choices=settings.ACCOUNT_TYPES, default=1)
    trial_start = models.DateTimeField(blank=True, null=True)
    trial_end = models.DateTimeField(blank=True, null=True)
    current_plan_end = models.DateTimeField(blank=True, null=True)
    is_admin = models.BooleanField(default=False)
    is_active = models.BooleanField(default=False)
    is_verified = models.BooleanField(default=False)
    is_banned = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    last_login = models.DateTimeField(auto_now=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = CustomAccountManager()

    def get_auth_phone(self):
        try:
            auth_phone = phonenumbers.parse(str(self.auth_phone), None)
        except phonenumbers.NumberParseException as e:
            return None
        return auth_phone

    def is_2fa_on(self):
        if self.verification_code is not None and self.otp_verified:
            return True
        else:
            return False

    def __str__(self):
        return self.first_name + ' ' + self.last_name

    def has_perm(self, perm, obj=None):
        return self.is_admin

    def has_module_perms(self, app_label):
        return True

    def tokens(self):
        refresh = RefreshToken.for_user(self)
        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token)
        }

    """ get user's full name"""
    def full_name(self):
        return f'{self.first_name} {self.last_name}'

    """ get profile """
    def profile(self):
        return settings.ACCOUNT_TYPES[self.account_type][1]

    """ get current subscription type """
    def current_subscription(self):
        if self.trial_end <= datetime.now():
            return 'trial'

        if self.current_plan_end >= datetime.now():
            return 'subscribed'

        return 'expired'


""" method used to update elroi_id when new user is created """
def update_user_elroi_id(sender, instance, created, **kwargs):
    if created:
        token = secrets.token_hex(3).upper()
        account_type = 'C'
        if instance.account_type == 1:
            account_type = 'E'
        instance.elroi_id = f'{account_type}-{token}'
        instance.save()


""" check and generate unique elroi_id"""
def check_unique_elroi_id(elroi_id):
    user = Account.objects.get(elroi_id__exact=elroi_id)
    account_type = elroi_id[0]
    if user.exists():
        elroi_id = generate_id(account_type)
        check_unique_elroi_id(elroi_id)
    return elroi_id


"""generate random id ( characters+ digits)"""
def generate_id(account_type='C'):
    token = secrets.token_hex(3).upper()
    return f'{account_type}-{token}'


"""call signal to update elroi id when account is created"""
post_save.connect(update_user_elroi_id, sender=Account)
