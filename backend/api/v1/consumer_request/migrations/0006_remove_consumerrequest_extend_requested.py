# Generated by Django 3.1.1 on 2020-11-15 20:30

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('consumer_request', '0005_auto_20201113_2024'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='consumerrequest',
            name='extend_requested',
        ),
    ]
