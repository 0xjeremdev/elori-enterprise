# Generated by Django 2.2.15 on 2020-11-06 20:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0002_auto_20201106_1938'),
    ]

    operations = [
        migrations.RenameField(
            model_name='enterprise',
            old_name='company_notification_email',
            new_name='notification_email',
        ),
        migrations.AlterField(
            model_name='enterprise',
            name='additional_emails',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
    ]