# Generated by Django 3.1.1 on 2020-11-15 20:47

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('consumer_request', '0006_remove_consumerrequest_extend_requested'),
    ]

    operations = [
        migrations.AlterField(
            model_name='consumerrequest',
            name='request_date',
            field=models.DateTimeField(blank=True, default=datetime.datetime.utcnow, null=True),
        ),
    ]
