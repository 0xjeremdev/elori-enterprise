# Generated by Django 2.2.15 on 2020-11-03 23:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('assessment', '0003_assessment_created_by'),
    ]

    operations = [
        migrations.AddField(
            model_name='assessment',
            name='share_hash',
            field=models.CharField(default=1, max_length=255),
            preserve_default=False,
        ),
    ]
