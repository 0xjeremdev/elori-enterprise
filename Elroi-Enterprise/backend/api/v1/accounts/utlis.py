import pyotp
from django.core.mail import EmailMessage


class SendUserEmail:
    @staticmethod
    def send_email(data):
        email = EmailMessage(
            subject=data['email_subject'],
            body=data['email_body'],
            to=[data['to_email']]
        )
        email.content_subtype = 'html'
        email.send()


def generate_verification_code():
    totp = pyotp.TOTP('base32secret3232')
    return totp.now()
