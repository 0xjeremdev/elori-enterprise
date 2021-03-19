from django.contrib import admin
from django import forms
from .models import ConsumerRequest, DataReturnModel
# Register your models here.


@admin.register(ConsumerRequest)
class ConsumerRequestAdmin(admin.ModelAdmin):
    list_display = ("email", )


@admin.register(DataReturnModel)
class DataReturnAdmin(admin.ModelAdmin):
    list_display = (
        "file",
        "consumer_request",
        "link_id",
        "code",
        "downloaded",
        "lifetime",
    )
