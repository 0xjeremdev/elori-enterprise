from django.contrib import admin
from .models import Files
# Register your models here.


@admin.register(Files)
class FilesAdmin(admin.ModelAdmin):
    list_display = ("name", "size", "file_type", "created_at")
