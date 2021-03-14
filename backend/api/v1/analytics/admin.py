from django.contrib import admin
from .models import ActivityLog
# Register your models here.


@admin.register(ActivityLog)
class ActivityLogAdmin(admin.ModelAdmin):
    list_display = ("user", "elroi_id", "requested_at", "path", "view",
                    "view_method", "remote_addr")
