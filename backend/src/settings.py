import datetime
import os
from pathlib import Path

from dotenv import load_dotenv, find_dotenv
from django.core.exceptions import ImproperlyConfigured

load_dotenv(find_dotenv())

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


def get_env_value(env_variable):
    try:
        return os.getenv(env_variable)
    except KeyError:
        raise ImproperlyConfigured(
            f'Set the "{env_variable}" environment variable.')


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "nw34t1ljtpz0q+c08&#80ihi%if$9wslxn&g1ad60fj3mdpamr"

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = get_env_value("DEBUG")

ALLOWED_HOSTS = ["*"]
APPEND_SLASH = False
# Application definition

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "api.v1.accounts",
    "api.v1.enterprise",
    "api.v1.consumer_request",
    "api.v1.elroi_admin",
    "api.v1.analytics",
    "api.v1.assessment",
    "frontend.home",
    "django_otp",
    "django_otp.plugins.otp_totp",
    "django_otp.plugins.otp_static",
    "rest_framework",
    "rest_framework_simplejwt.token_blacklist",
    "corsheaders",
    "drf_yasg",
]

SWAGGER_SETTINGS = {
    "SECURITY_DEFINITIONS": {
        "Bearer": {
            "type": "apiKey",
            "name": "Authorization",
            "in": "header"
        }
    },
    "VALIDATOR_URL": "http://localhost:8189",
}

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "src.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [os.path.join(BASE_DIR, "templates")],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "src.wsgi.application"

AUTH_USER_MODEL = "accounts.Account"

CORS_ORIGIN_ALLOW_ALL = True
# CORS WHITELIST
# CORS_ORIGIN_WHITELIST = [
#     "http://localhost:3000",
#     "http://127.0.0.1:8080",
#     "http://10.209.18.180:8080",
#     "http://10.209.18.180:8080",
# ]

# CORS_ORIGIN_REGEX_WHITELIST = []

# Database
# https://docs.djangoproject.com/en/3.1/ref/settings/#databases

# DATABASES = {
#     "default": {
#         "ENGINE": "django.db.backends.sqlite3",
#         "NAME": str(BASE_DIR.joinpath("db.sqlite3").resolve()),
#     }
# }

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "elroi_enterprise",
        "USER": "custdbuser",
        "PASSWORD": "Custz3!tqvYK@",
        "HOST": "localhost",
        "PORT": "5432",
    }
}

STATUSES = (
    (0, "For Review"),
    (1, "Approved"),
    (2, "Processing"),
    (3, "Complete"),
    (4, "Rejected"),
)

REQUEST_TYPES = (
    (0, "Return"),
    (1, "Modify"),
    (2, "Delete"),
)

REST_FRAMEWORK = {
    "DEFAULT_PAGINATION_CLASS":
    "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE":
    10,
    "NON_FIELD_ERRORS_KEY":
    "error",
    "DEFAULT_AUTHENTICATION_CLASSES":
    ("rest_framework_simplejwt.authentication.JWTAuthentication", ),
}

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": datetime.timedelta(minutes=300),
    "REFRESH_TOKEN_LIFETIME": datetime.timedelta(days=1),
    "ROTATE_REFRESH_TOKENS": False,
    "BLACKLIST_AFTER_ROTATION": True,
    "ALGORITHM": "HS256",
    "SIGNING_KEY": SECRET_KEY,
    "VERIFYING_KEY": None,
    "AUDIENCE": None,
    "ISSUER": None,
    "AUTH_HEADER_TYPES": ("Bearer", ),
    "USER_ID_FIELD": "id",
    "USER_ID_CLAIM": "user_id",
    "AUTH_TOKEN_CLASSES": ("rest_framework_simplejwt.tokens.AccessToken", ),
    "TOKEN_TYPE_CLAIM": "token_type",
    "JTI_CLAIM": "jti",
    "SLIDING_TOKEN_REFRESH_EXP_CLAIM": "refresh_exp",
    "SLIDING_TOKEN_LIFETIME": datetime.timedelta(minutes=15),
    "SLIDING_TOKEN_REFRESH_LIFETIME": datetime.timedelta(days=1),
}
# Password validation
# https://docs.djangoproject.com/en/3.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME":
        "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME":
        "django.contrib.auth.password_validation.MinimumLengthValidator",
        "OPTIONS": {
            "min_length": 12
        },
    },
    {
        "NAME":
        "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME":
        "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]

# Internationalization
# https://docs.djangoproject.com/en/3.1/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_L10N = True

USE_TZ = False

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.1/howto/static-files/

STATIC_URL = "/static/"
MEDIA_URL = "/media/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "static"),
]

MEDIA_ROOT = os.path.join(BASE_DIR, "media")

UPLOAD_FOLDER = os.path.join(BASE_DIR, "media/requests_docs")
UPLOAD_USER_GUIDE_FOLDER = os.path.join(BASE_DIR, "media/user_guide")

# FRONTEND_URL = get_env_value("FRONTEND_URL")

# DEFAULT_FROM_EMAIL = get_env_value("DEFAULT_FROM_EMAIL")
# EMAIL_HOST = get_env_value("EMAIL_HOST")
# EMAIL_HOST_USER = get_env_value("EMAIL_HOST_USER")
# EMAIL_HOST_PASSWORD = get_env_value("EMAIL_HOST_PASSWORD")
# EMAIL_PORT = get_env_value("EMAIL_PORT")
# EMAIL_USE_TLS = get_env_value("EMAIL_USE_TLS")

EMAIL_HOST = "smtp.sendgrid.net"
EMAIL_HOST_USER = "apikey"
EMAIL_HOST_PASSWORD = "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"
EMAIL_PORT = 587
EMAIL_USE_TLS = True
DEFAULT_FROM_EMAIL = "no-reply@elroi.ai"

FRONTEND_URL = get_env_value("FRONTEND_URL")
