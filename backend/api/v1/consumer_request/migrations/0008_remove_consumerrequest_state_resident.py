# Generated by Django 3.1.1 on 2021-01-20 16:35

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('consumer_request', '0007_auto_20201115_2047'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='consumerrequest',
            name='state_resident',
        ),
    ]
