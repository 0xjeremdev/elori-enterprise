# Generated by Django 3.1.1 on 2021-03-17 19:34

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('consumer_request', '0023_auto_20210317_1917'),
    ]

    operations = [
        migrations.AddField(
            model_name='datareturnmodel',
            name='downloaded',
            field=models.BooleanField(default=False),
        ),
    ]
