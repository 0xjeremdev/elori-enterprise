# Generated by Django 3.1.1 on 2021-03-17 19:17

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('consumer_request', '0022_auto_20210313_2213'),
    ]

    operations = [
        migrations.AlterField(
            model_name='datareturnmodel',
            name='consumer_request',
            field=models.OneToOneField(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='request_dataReturn', to='consumer_request.consumerrequest'),
        ),
    ]
