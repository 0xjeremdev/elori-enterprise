import pyotp
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

from api.v1.accounts.models import Account, Customer, Enterprise


def generate_auth_code():
    totp = pyotp.TOTP('base32secret3232')
    auth_code = totp.now()
    return auth_code

# Register Serializer, used when new account is created
class RegisterSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(min_length=6, max_length=80, required=True,
                                   validators=[UniqueValidator(queryset=Account.objects.all())])
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    state_resident = serializers.BooleanField(required=True)
    two_fa_valid = serializers.BooleanField(read_only=True, required=False)
    account_type = serializers.IntegerField(required=False)
    password = serializers.CharField(min_length=8, write_only=True)

    class Meta:
        model = Account
        fields = ('elroi_id', 'email', 'full_name', 'first_name', 'last_name', 'two_fa_valid', 'account_type', 'profile', 'state_resident', 'tokens', 'password')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = Account.objects.create_front_user(
            validated_data['state_resident'], validated_data['first_name'],
            validated_data['last_name'], validated_data['email'],
            validated_data['password'],
            validated_data['account_type']
        )
        return user

    def validate(self, data):
        email = data.get('email', '')
        password = data.get('password', '')
        first_name = data.get('first_name', '')
        last_name = data.get('last_name', '')
        state_resident = data.get('state_resident')
        account_type = data.get('account_type')

        user = Account.objects.filter(email__iexact=email)
        if user.exists():
            raise ValidationError('This email is already registered in our database.', code=status.HTTP_400_BAD_REQUEST)

        return super().validate(data)


# Login Serializer, validate and login existing users
class LoginSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(min_length=6, max_length=80, required=True)
    password = serializers.CharField(min_length=8, write_only=True)
    two_fa_valid = serializers.BooleanField(read_only=True, required=False)
    username = serializers.CharField(required=False)

    class Meta:
        model = Account
        fields = ('email', 'two_fa_valid', 'tokens', 'password', 'username')

    def validate(self, data):
        email = data.get('email', '')
        password = data.get('password', '')
        user = authenticate(email=email, password=password)
        if not user:
            raise AuthenticationFailed('Invalid credentials, try again.')
        if not user.is_active:
            raise AuthenticationFailed('Account disabled, contact admin.')
        if not user.is_verified:
            raise AuthenticationFailed('Account is not verified.')

        return {
            'email': user.email,
            'two_fa_valid': user.is_2fa_on(),
            'tokens': user.tokens(),
        }

class CustomerSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(min_length=6, max_length=80, required=True,
                                   validators=[UniqueValidator(queryset=Customer.objects.all())])
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    state_resident = serializers.BooleanField(required=True)
    two_fa_valid = serializers.BooleanField(read_only=True, required=False)
    password = serializers.CharField(min_length=8, write_only=True)
    elroi_id = serializers.CharField(required=False)
    file = serializers.FileField()

    class Meta:
        model = Customer
        fields = '__all__'
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        try:
            user = Account.objects.create_front_user(validated_data['email'], validated_data['password'])
            del validated_data['password']
            customer = Customer.objects.create(user=user, **validated_data)
            return customer
        except IntegrityError as e:
            raise ValidationError('This email is already registered in our database.', code=status.HTTP_400_BAD_REQUEST)

""" register enterprise class serializer """
class RegisterEnterpriseSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(min_length=6, max_length=80, required=True,
                                   validators=[UniqueValidator(queryset=Customer.objects.all())])
    name = serializers.CharField(min_length=3, max_length=255, required=True)
    web = serializers.URLField(required=False)
    two_fa_valid = serializers.BooleanField(read_only=True, required=False)
    password = serializers.CharField(min_length=8, write_only=True)
    elroi_id = serializers.CharField(required=False)

    class Meta:
        model = Enterprise
        fields = '__all__'
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        try:
            user = Account.objects.create_front_user(validated_data['email'], validated_data['password'])
            del validated_data['password']
            enterprise = Enterprise.objects.create(user=user, **validated_data)
            return enterprise
        except IntegrityError as e:
            raise ValidationError('This email is already registered in our database.', code=status.HTTP_400_BAD_REQUEST)

""" user serializer class """
class UserSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required=True)
    state_resident = serializers.BooleanField()
    first_name = serializers.CharField()
    last_name = serializers.CharField()
    password = serializers.CharField(
        min_length=8,
        write_only=True,
        required=True
    )

    class Meta:
        model = Account
        fields = ('email', 'state_resident', 'first_name', 'last_name', 'password')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        if password is not None:
            instance.set_password(password)

        instance.save()
        return instance

class EmailVerificationSerializer(serializers.ModelSerializer):
    token = serializers.CharField(max_length=555)

    class Meta:
        model = Account
        fields = ['token']


class ResetPasswordEmailRequestSerializer(serializers.Serializer):
    email = serializers.EmailField(min_length=6)

    redirect_url = serializers.CharField(max_length=500, required=False)

    class Meta:
        fields = ['email']


class LogoutSerializer(serializers.Serializer):
    refresh = serializers.CharField()
    default_error_messages = {
        'bad_token': 'Token is expired or invalid'
    }

    def validate(self, data):
        self.token = data['refresh']
        return data

    def save(self, **kwargs):
        try:
            RefreshToken(self.token).blacklist()
        except TokenError:
            self.fail('bad_token')


class PasswordResetSerializer(serializers.Serializer):
    email = serializers.EmailField(min_length=8)
    redirect_url = serializers.CharField(max_length=500, required=False)

    class Meta:
        fields = ['email']


class PasswordCofirmationSerializer(serializers.Serializer):
    password = serializers.CharField(min_length=8, write_only=True)
    token = serializers.CharField(write_only=True, min_length=8)
    uidb64 = serializers.CharField(write_only=True)

    class Meta:
        fields = ['password', 'token', 'uidb64']

    def validate(self, attrs):
        try:
            password = attrs.get('password')
            token = attrs.get('token')
            uidb64 = attrs.get('uidb64')
            id = force_str(urlsafe_base64_decode(uidb64))
            user = Account.objects.get(id=id)
            if not PasswordResetTokenGenerator().check_token(user, token):
                raise AuthenticationFailed('The reset link is invalid')
            user.set_password(password)
            user.save()

            return user
        except Exception as e:
            raise AuthenticationFailed('The reset link is invalid')

        return super().validate(attrs)


""" Serializer used to generate and send verification code for 2FA, to the user."""


class EmailValidationCodeSerializer(serializers.Serializer):
    email = serializers.EmailField(required=True)
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
            return {
                'email': user.email,
                'tokens': user.tokens()
            }
        else:
            raise ValidationError("Invalid email address")


""" confirm the verification code received from email """


class VerificationCodeSerializer(serializers.Serializer):
    verification_code = serializers.IntegerField(required=True)
    email = serializers.EmailField(required=False, read_only=True)
    tokens = serializers.JSONField(required=False, read_only=True)
    otp_verified = serializers.BooleanField(required=False, read_only=True)

    class Meta:
        model = Account
        fields = {'email', 'verification_code', 'tokens', 'otp_verified'}

    def validate(self, data):
        if Account.objects.filter(verification_code=data.get('verification_code')).exists():
            user = Account.objects.get(verification_code=data.get('verification_code'))
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
