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
