# Generated by Django 2.2.15 on 2020-10-21 19:31

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('enterprise', '0003_enterpriseconfigurationmodel'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='userguide',
            options={'ordering': ['-created_at']},
        ),
    ]
