from django.urls import path

from api.v1.elroi_admin.views import (
    EnterpriseActivityApi, EnterpriseApi, EnterpriseCustomersApi,
    EnterpriseMaintenanceApi, EnterpriseTrialConfigApi
)

urlpatterns = [
    path('activity-log', EnterpriseActivityApi.as_view(), name="admin_activity_log"),
    path('enterprise', EnterpriseApi.as_view(), name="admin_enterprise"),
    path('enterprise/customers', EnterpriseCustomersApi.as_view(), name="admin_enterprise_customers"),
    path('enterprise/maintenance/', EnterpriseMaintenanceApi.as_view(), name="admin_enterprise_maintenance"),
    path('enterprise/trial-config', EnterpriseTrialConfigApi.as_view(), name="admin_enterprise_trial_config"),
]
