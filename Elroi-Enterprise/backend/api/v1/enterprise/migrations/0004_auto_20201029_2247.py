# Generated by Django 2.2.15 on 2020-10-29 22:47

import django.contrib.postgres.fields.jsonb
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('enterprise', '0003_auto_20201029_2213'),
    ]

    operations = [
        migrations.AlterField(
            model_name='enterpriseconfigurationmodel',
            name='additional_configuration',
            field=django.contrib.postgres.fields.jsonb.JSONField(blank=True, default={}),
        ),
    ]
