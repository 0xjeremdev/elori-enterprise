# Generated by Django 3.1.1 on 2021-02-05 17:56

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('consumer_request', '0011_auto_20210122_1958'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='consumerrequest',
            name='additional_fields',
        ),
        migrations.RemoveField(
            model_name='consumerrequest',
            name='file',
        ),
    ]
