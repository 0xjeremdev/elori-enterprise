# Generated by Django 2.2.15 on 2020-10-30 15:01

import django.contrib.postgres.fields.jsonb
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('consumer_request', '0006_auto_20201029_1743'),
    ]

    operations = [
        migrations.AddField(
            model_name='consumerrequest',
            name='request_form',
            field=django.contrib.postgres.fields.jsonb.JSONField(blank=True, null=True),
        ),
    ]
