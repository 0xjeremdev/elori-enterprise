import pyotp
import os
from django.core.mail import EmailMessage, send_mail
from django.conf import settings


class SendUserEmail:
    @staticmethod
    def send_email(data):
        try:
            send_mail(
                subject=data["email_subject"],
                html_message=data["email_body"],
                message="",
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[data["to_email"]],
            )
        except Exception as e:
            print(e)


def generate_verification_code():
    totp = pyotp.TOTP("base32secret3232")
    return totp.now()


def validate_password_strength(password):
    min_length = 12
    errors = []
    flag = False

    if len(password) < min_length:
        errors.append(
            _("Password must be at least {0} characters "
              "long.").format(min_length))
        flag = True

    # check for 2 digits
    if not any(c.isdigit() for c in password):
        errors.append("Password must contain at least 1 digit.")
        flag = True

    # check for uppercase letter
    if not any(c.isupper() for c in password):
        errors.append("Password must contain at least 1 uppercase letter.")
        flag = True

    # check for uppercase letter
    if not any(c.islower() for c in password):
        errors.append("Password must contain at least 1 lowecase letter.")
        flag = True
    if flag:
        raise ValidationError(errors)
    return password
