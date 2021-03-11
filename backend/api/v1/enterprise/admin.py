from django.contrib import admin
from django import forms
from .models import EnterpriseEmailType, EnterpriseConfigurationModel, Enterprise
# Register your models here.


@admin.register(EnterpriseEmailType)
class EnterpriseEmailTypeAdmin(admin.ModelAdmin):
    list_display = ("email_type", )


@admin.register(EnterpriseConfigurationModel)
class EnterpriseConfigurationAdmin(admin.ModelAdmin):
    list_display = ("enterprise_id", "website_launched_to")


@admin.register(Enterprise)
class EnterpriseAdmin(admin.ModelAdmin):
    list_display = ("pk", "user", "company_name")


# Register your models here.
