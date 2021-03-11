import pyotp
import base64
from django.conf import settings
from django.contrib.auth import authenticate
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.db import IntegrityError
from django.utils.encoding import force_str
from django.utils.http import urlsafe_base64_decode
from rest_framework import serializers, status
from rest_framework.exceptions import AuthenticationFailed, ValidationError
from rest_framework.fields import CharField
from rest_framework.validators import UniqueValidator
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.tokens import RefreshToken, TokenError

from api.v1.accounts.models import Account, Staff, Enterprise
from .utlis import validate_password_strength, generate_auth_code
from ..consumer_request.utils import validate_filesize, validate_filename
from ..upload.models import Files


# Register Serializer, used when new account is created
class RegisterSerializer(serializers.ModelSerializer):
    email = serializers.CharField(
        min_length=6,
        max_length=80,
        required=True,
        validators=[UniqueValidator(queryset=Account.objects.all())])
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    state_resident = serializers.BooleanField(required=True)
    two_fa_valid = serializers.BooleanField(read_only=True, required=False)
    account_type = serializers.IntegerField(required=False)
    password = serializers.CharField(min_length=8, write_only=True)

    class Meta:
        model = Account
        fields = ('elroi_id', 'email', 'full_name', 'first_name', 'last_name',
                  'two_fa_valid', 'account_type', 'profile', 'state_resident',
                  'tokens', 'password')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = Account.objects.create_front_user(
            validated_data['state_resident'], validated_data['first_name'],
            validated_data['last_name'], validated_data['email'],
            validated_data['password'], validated_data['account_type'])
        return user

    def validate(self, data):
        email = data.get('email', '')
        user = Account.objects.filter(email__iexact=email)
        if user.exists():
            raise ValidationError(
                'This email is already registered in our database.',
                code=status.HTTP_400_BAD_REQUEST)
        password = data.get('password', '')
        validate_password_strength(password)
        first_name = data.get('first_name', '')
        last_name = data.get('last_name', '')
        state_resident = data.get('state_resident')
        account_type = data.get('account_type')
        return super().validate(data)


# Login Serializer, validate and login existing users
class LoginSerializer(serializers.ModelSerializer):
    email = serializers.CharField(min_length=6, max_length=80, required=True)
    password = serializers.CharField(min_length=8, write_only=True)
    two_fa_valid = serializers.BooleanField(read_only=True, required=False)

    class Meta:
        model = Account
        fields = ('email', 'two_fa_valid', 'tokens', 'password')

    def validate(self, data):
        email = data.get('email', '')
        password = data.get('password', '')
        account = Account.objects.filter(email=email).first()
        if account == None:
            raise AuthenticationFailed("This email doesn't exist.")
        if account != None and account.is_locked:
            raise AuthenticationFailed('This accunt is locked.')

        user = authenticate(username=account.username, password=password)
        print(account.username)
        print(password)
        print(user)
        if not user:
            account.login_failed += 1
            account.save()
            if account.login_failed >= 4:
                account.login_failed = 0
                account.is_locked = True
                account.save()
                raise AuthenticationFailed('This accunt is locked.')
            raise AuthenticationFailed(
                "The password isn't correct. You can try more " +
                str(4 - account.login_failed) + " times.")
        if not user.is_active:
            raise AuthenticationFailed('Account disabled, contact admin.')
        if not user.is_verified:
            raise AuthenticationFailed('Account is not verified.')

        return {
            'email': user.email,
            'two_fa_valid': user.is_2fa_on(),
            'tokens': user.tokens(),
        }


class StaffSerializer(serializers.Serializer):
    enterprise_elroi_id = serializers.CharField(required=True)
    email = serializers.CharField(
        min_length=6,
        max_length=80,
        required=True,
        validators=[UniqueValidator(queryset=Account.objects.all())])
    username = serializers.CharField(
        min_length=3,
        max_length=255,
        required=True,
        validators=[UniqueValidator(queryset=Account.objects.all())])
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    two_fa_valid = serializers.BooleanField(read_only=True, required=False)
    password = serializers.CharField(min_length=8, write_only=True)

    class Meta:
        model = Staff
        fields = '__all__'
        extra_kwargs = {'password': {'write_only': True}}

    def validate(self, data):
        if validate_password_strength(data.get("password")):
            return data
        return None

    def create(self, validated_data):
        enterprise = Enterprise.objects.filter(
            user__elroi_id=validated_data['enterprise_elroi_id']).first()
        if enterprise == None:
            raise ValidationError("Enterprise doesn't exist",
                                  code=status.HTTP_400_BAD_REQUEST)
        user = Account.objects.create_front_user(validated_data['email'],
                                                 validated_data['username'],
                                                 validated_data['password'])
        user.first_name = validated_data['first_name'].capitalize()
        user.last_name = validated_data['last_name'].capitalize()
        user.is_member = True
        user.save()
        del validated_data['password']
        del validated_data['enterprise_elroi_id']

        staff = Staff.objects.create(user=user, enterprise=enterprise)
        return staff


""" register enterprise class serializer """


class RegisterEnterpriseSerializer(serializers.ModelSerializer):
    email = serializers.CharField(
        min_length=6,
        max_length=80,
        required=True,
        validators=[UniqueValidator(queryset=Account.objects.all())])
    username = serializers.CharField(
        min_length=3,
        max_length=255,
        required=True,
        validators=[UniqueValidator(queryset=Account.objects.all())])
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    company_name = serializers.CharField(required=True)
    two_fa_valid = serializers.BooleanField(read_only=True, required=False)
    password = serializers.CharField(min_length=12, write_only=True)
    elroi_id = serializers.CharField(required=False)

    class Meta:
        model = Account
        fields = '__all__'
        extra_kwargs = {'password': {'write_only': True}}

    def validate(self, data):
        if validate_password_strength(data.get("password")):
            return data
        return data

    def create(self, validated_data):
        try:
            user = Account.objects.create_front_user(
                validated_data['email'], validated_data['username'],
                validated_data['password'])
            user.first_name = validated_data['first_name'].capitalize()
            user.last_name = validated_data['last_name'].capitalize()
            user.is_enterprise = True
            user.save()
            del validated_data['password']
            enterprise = Enterprise.objects.create(
                user=user, company_name=validated_data['company_name'])
            return enterprise
        except IntegrityError as e:
            raise ValidationError(
                'This email is already registered in our database.',
                code=status.HTTP_400_BAD_REQUEST)


class EmailVerificationSerializer(serializers.ModelSerializer):
    token = serializers.CharField(max_length=555)

    class Meta:
        model = Account
        fields = ['token']


class ResetPasswordEmailRequestSerializer(serializers.Serializer):
    email = serializers.CharField(min_length=6)

    redirect_url = serializers.CharField(max_length=500, required=False)

    class Meta:
        fields = ['email']


class LogoutSerializer(serializers.Serializer):
    refresh = serializers.CharField()
    default_error_messages = {'bad_token': 'Token is expired or invalid'}

    def validate(self, data):
        self.token = data['refresh']
        return data

    def save(self, **kwargs):
        try:
            RefreshToken(self.token).blacklist()
        except TokenError:
            self.fail('bad_token')


class PasswordResetSerializer(serializers.Serializer):
    email = serializers.CharField(min_length=8)

    class Meta:
        fields = ['email']


class PasswordCofirmationSerializer(serializers.Serializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        fields = ['password']

    def validate(self, data):
        password = data.get('password')
        validate_password_strength(password)
        return data


""" Serializer used to generate and send verification code for 2FA, to the user."""


class EmailValidationCodeSerializer(serializers.Serializer):
    email = serializers.CharField(required=True)
    tokens = serializers.JSONField(required=False, read_only=True)

    class Meta:
        model = Account
        fields = {'email'}

    def validate(self, data):
        if Account.objects.filter(email__iexact=data.get('email')).exists():
            user = Account.objects.get(email=data.get('email'))
            verification_code = generate_auth_code()
            user.verification_code = verification_code
            user.otp_verified = False
            user.save()
            return {'email': user.email, 'tokens': user.tokens()}
        else:
            raise ValidationError("Invalid email address")


""" confirm the verification code received from email """


class VerificationCodeSerializer(serializers.Serializer):
    verification_code = serializers.CharField(min_length=6, write_only=True)
    email = serializers.CharField(required=False, read_only=True)
    tokens = serializers.JSONField(required=False, read_only=True)
    otp_verified = serializers.BooleanField(required=False, read_only=True)

    class Meta:
        model = Account
        fields = {'email', 'verification_code', 'tokens', 'otp_verified'}

    def validate(self, data):
        request = self.context.get("request")
        user = request.user
        if user.verification_code == data.get('verification_code'):
            user.otp_verified = True
            user.save()
            return {
                'email': user.email,
                'verification_code': user.verification_code,
                'tokens': user.tokens(),
                'otp_verified': user.otp_verified,
            }
        else:
            raise ValidationError("Invalid Verification Code.")


class UserTokenSerializer(TokenObtainPairSerializer):
    token = CharField(min_length=7, required=True)


class AccountProfileSettingsSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(read_only=True)
    email = serializers.CharField(read_only=True)
    logo_data = serializers.SerializerMethodField()
    logo = serializers.FileField(required=False, write_only=True)
    first_name = serializers.CharField(required=False)
    last_name = serializers.CharField(required=False)
    company_email = serializers.CharField(required=False)
    phone_number = serializers.CharField(required=False)
    company_name = serializers.CharField(required=False)
    timezone = serializers.CharField(required=False)
    is_2fa_active = serializers.BooleanField(required=False)

    class Meta:
        model = Account
        fields = [
            'id', 'email', 'logo', 'logo_data', 'first_name', 'last_name',
            'company_email', 'phone_number', 'company_name', 'timezone',
            'is_2fa_active'
        ]

    def get_logo_data(self, obj):
        if not obj.logo:
            return None
        return {
            "name": obj.logo.name,
            "size": obj.logo.size,
            "content": base64.b64encode(obj.logo.content).decode('utf-8'),
            "type": obj.logo.file_type
        }

    def validate(self, data):
        request = self.context.get("request")
        if "logo" in request.FILES:
            if not validate_filename(request.FILES.get("logo")):
                raise Exception("Invalid filetype")
            if not validate_filesize(request.FILES.get("logo")):
                raise Exception(
                    "Too large filesize. The file should be less than 5MB.")
        data["first_name"] = data.get("first_name").capitalize()
        data["last_name"] = data.get("last_name").capitalize()
        return super().validate(data)

    def update(self, instance, validated_data):
        request = self.context.get("request")
        account = request.user
        if "logo" in request.FILES:
            if not account.logo:
                account.logo = Files.create(file=request.FILES.get("logo"))
            else:
                account.logo.update(file=request.FILES.get("logo"))
            del validated_data["logo"]
        account.save()
        return super().update(instance, validated_data)
