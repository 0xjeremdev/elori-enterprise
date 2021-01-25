from django.contrib import admin
from django import forms
from .models import EnterpriseEmailType
# Register your models here.


@admin.register(EnterpriseEmailType)
class EnterpriseEmailTypeAdmin(admin.ModelAdmin):
    list_display = ("email_type", )


# Register your models here.
