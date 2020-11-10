import pyotp
import os
from django.core.mail import EmailMessage
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from dotenv import load_dotenv, find_dotenv
from django.conf import settings

class SendUserEmail:
    @staticmethod
    def send_email(data):
        message = Mail(
            from_email=settings.DEFAULT_FROM_EMAIL,
            to_emails=data['to_email'],
            subject=data['email_subject'],
            html_content=data['email_body'])
        try:
            sg = SendGridAPIClient(settings.SENDGRID_API_KEY)
            response = sg.send(message)
            print(response.status_code)
        except Exception as e:
            print(e.message)


def generate_verification_code():
    totp = pyotp.TOTP('base32secret3232')
    return totp.now()
