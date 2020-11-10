import pyotp
from django.core.mail import send_mail
from django.conf import settings

class SendUserEmail:
    @staticmethod
    def send_email(data):
        send_mail(
            data['email_subject'],
            data['email_body'],
            settings.DEFAULT_FROM_EMAIL,
            [data['to_email']]
        )


def generate_verification_code():
    totp = pyotp.TOTP('base32secret3232')
    return totp.now()
