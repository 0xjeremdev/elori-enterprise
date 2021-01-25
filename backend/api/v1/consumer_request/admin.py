from django.contrib import admin
from django import forms
from .models import ConsumerRequest
# Register your models here.


@admin.register(ConsumerRequest)
class ConsumerRequestAdmin(admin.ModelAdmin):
    list_display = ("email", )
