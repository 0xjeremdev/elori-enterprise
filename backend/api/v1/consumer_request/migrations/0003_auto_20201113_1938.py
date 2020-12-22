# Generated by Django 3.1.1 on 2020-11-13 19:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('consumer_request', '0002_auto_20201113_0321'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='consumerrequest',
            name='description',
        ),
        migrations.RemoveField(
            model_name='consumerrequest',
            name='elroi_id',
        ),
        migrations.RemoveField(
            model_name='consumerrequest',
            name='request_form',
        ),
        migrations.RemoveField(
            model_name='consumerrequest',
            name='title',
        ),
        migrations.AddField(
            model_name='consumerrequest',
            name='additional_fields',
            field=models.JSONField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='consumerrequest',
            name='email',
            field=models.EmailField(blank=True,
                                    max_length=60,
                                    null=True,
                                    unique=True,
                                    verbose_name='Email'),
        ),
        migrations.AddField(
            model_name='consumerrequest',
            name='file',
            field=models.FileField(blank=True, null=True, upload_to=''),
        ),
        migrations.AddField(
            model_name='consumerrequest',
            name='first_name',
            field=models.CharField(max_length=40, null=True),
        ),
        migrations.AddField(
            model_name='consumerrequest',
            name='last_name',
            field=models.CharField(max_length=40, null=True),
        ),
        migrations.AddField(
            model_name='consumerrequest',
            name='state_resident',
            field=models.BooleanField(default=False),
        ),
    ]
