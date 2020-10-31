# Generated by Django 2.2.15 on 2020-10-30 15:01

import django.contrib.postgres.fields.jsonb
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0016_customeruploads'),
    ]

    operations = [
        migrations.AddField(
            model_name='customer',
            name='additional_fields',
            field=django.contrib.postgres.fields.jsonb.JSONField(default=1),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='customer',
            name='email',
            field=models.EmailField(blank=True, max_length=60, null=True, unique=True, verbose_name='Email'),
        ),
        migrations.DeleteModel(
            name='CustomerUploads',
        ),
    ]
