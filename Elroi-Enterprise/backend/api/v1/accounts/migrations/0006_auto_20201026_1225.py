# Generated by Django 2.2.15 on 2020-10-26 12:25

from django.conf import settings
import django.contrib.auth.validators
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0005_auto_20201021_2232'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='account',
            name='account_type',
        ),
        migrations.RemoveField(
            model_name='account',
            name='auth_id',
        ),
        migrations.RemoveField(
            model_name='account',
            name='auth_phone',
        ),
        migrations.RemoveField(
            model_name='account',
            name='current_plan_end',
        ),
        migrations.RemoveField(
            model_name='account',
            name='elroi_id',
        ),
        migrations.RemoveField(
            model_name='account',
            name='state_resident',
        ),
        migrations.RemoveField(
            model_name='account',
            name='trial_end',
        ),
        migrations.RemoveField(
            model_name='account',
            name='trial_start',
        ),
        migrations.AlterField(
            model_name='account',
            name='first_name',
            field=models.CharField(blank=True, default=1, max_length=30, verbose_name='first name'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='account',
            name='last_name',
            field=models.CharField(blank=True, default=2, max_length=150, verbose_name='last name'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='account',
            name='username',
            field=models.CharField(error_messages={'unique': 'A user with that username already exists.'}, help_text='Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.', max_length=150, unique=True, validators=[django.contrib.auth.validators.UnicodeUsernameValidator()], verbose_name='username'),
        ),
        migrations.CreateModel(
            name='Enterprise',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('elroi_id', models.CharField(db_index=True, max_length=9, unique=True)),
                ('state_resident', models.BooleanField(default=False)),
                ('first_name', models.CharField(max_length=40, null=True)),
                ('last_name', models.CharField(max_length=40, null=True)),
                ('name', models.CharField(max_length=255)),
                ('web', models.CharField(blank=True, max_length=255, null=True)),
                ('trial_start', models.DateTimeField(blank=True, null=True)),
                ('trial_end', models.DateTimeField(blank=True, null=True)),
                ('current_plan_end', models.DateTimeField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='enterprise', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'enterprises',
            },
        ),
        migrations.CreateModel(
            name='Customer',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('elroi_id', models.CharField(db_index=True, max_length=9, unique=True)),
                ('email', models.EmailField(max_length=60, unique=True, verbose_name='Email')),
                ('username', models.CharField(max_length=30, unique=True)),
                ('first_name', models.CharField(max_length=40, null=True)),
                ('last_name', models.CharField(max_length=40, null=True)),
                ('state_resident', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='customer', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'customers',
            },
        ),
    ]
