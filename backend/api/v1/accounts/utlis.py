import pyotp
import math
import random
import os
import string
from django.core.mail import EmailMessage, send_mail
from django.conf import settings
from rest_framework.exceptions import AuthenticationFailed, ValidationError


class SendUserEmail:
    @staticmethod
    def send_email(data):
        try:
            # send_mail(
            #     subject=data["email_subject"],
            #     html_message=data["email_body"],
            #     message="",
            #     from_email=settings.DEFAULT_FROM_EMAIL,
            #     recipient_list=[data["to_email"]],
            # )
            mail = EmailMessage(subject=data["email_subject"],
                                from_email=settings.DEFAULT_FROM_EMAIL,
                                to=[data["to_email"]],
                                body=data["email_body"])
            mail.content_subtype = "html"
            # if "attachment" in data and data["attachment"] is not None:
            #     mail.attach(data["attachment"].name,
            #                 data["attachment"].content,
            #                 data["attachment"].file_type)
            mail.send()
        except Exception as e:
            print(e)


def generate_auth_code():
    digits = "0123456789"
    OTP = ""
    for i in range(6):
        OTP += digits[math.floor(random.random() * 10)]
    return OTP


def generate_verification_code():
    totp = pyotp.TOTP("base32secret3232")
    return totp.now()


def validate_password_strength(password):
    min_length = 12
    errors = []
    flag = False

    if len(password) < min_length:
        errors.append(f"Password must be at least {min_length} characters "
                      "long.")
        flag = True

    # check for 1 digits
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

    # check for special letter
    special_characters = string.punctuation
    special_bools = list(map(lambda char: char in special_characters,
                             password))
    if not any(special_bools):
        errors.append("Password must contain at least 1 special letter.")
        flag = True
    if flag:
        raise ValidationError(errors)
    return password
