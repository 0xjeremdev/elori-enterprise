import pyotp
import os
from django.core.mail import EmailMessage
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from dotenv import load_dotenv, find_dotenv

class SendUserEmail:
    @staticmethod
    def send_email(data):
        # email = EmailMessage(
        #     subject=data['email_subject'],
        #     body=data['email_body'],
        #     to=[data['to_email']]
        # )
        # email.content_subtype = 'html'
        # email.send()
        message = Mail(
            from_email=os.getenv('DEFAULT_FROM_EMAIL'),
            to_emails=data['to_email'],
            subject=data['email_subject'],
            html_content=data['email_body'])
        try:
            sg = SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
            response = sg.send(message)
            print(response.status_code)
            print(response.body)
            print(response.headers)
        except Exception as e:
            print(e)


def generate_verification_code():
    totp = pyotp.TOTP('base32secret3232')
    return totp.now()
