# Generated by Django 3.1.1 on 2020-11-13 03:21

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('consumer_request', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='consumerrequest',
            name='request_form',
            field=models.JSONField(blank=True, null=True),
        ),
    ]
