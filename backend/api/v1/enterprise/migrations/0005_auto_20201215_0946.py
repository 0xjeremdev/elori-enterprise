# Generated by Django 3.1.1 on 2020-12-15 09:46

from django.db import migrations, models
import uuid


class Migration(migrations.Migration):

    dependencies = [
        ('enterprise', '0004_enterpriseinvitemodel'),
    ]

    operations = [
        migrations.AlterField(
            model_name='enterpriseinvitemodel',
            name='invite_key',
            field=models.UUIDField(default=uuid.UUID('538cf9f2-81c4-4c94-97fe-d7ac1e23a8e0'), unique=True),
        ),
    ]
