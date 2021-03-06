from django.urls import path

from api.v1.elroi_admin.views import (EnterpriseActivityApi, EnterpriseApi,
                                      EnterpriseMaintenanceApi,
                                      EnterpriseTrialConfigApi, AssessmentApi,
                                      AssessmentResultApi, UserGuideUploadApi)

urlpatterns = [
    path('activity-log',
         EnterpriseActivityApi.as_view(),
         name="admin_activity_log"),
    path('enterprise', EnterpriseApi.as_view(), name="admin_enterprise"),
    # path('enterprise/customers', EnterpriseCustomersApi.as_view(), name="admin_enterprise_customers"),
    path('enterprise/maintenance/',
         EnterpriseMaintenanceApi.as_view(),
         name="admin_enterprise_maintenance"),
    path('enterprise/trial-config',
         EnterpriseTrialConfigApi.as_view(),
         name="admin_enterprise_trial_config"),
    path('assessment', AssessmentApi.as_view(), name='admin_assessment'),
    path('assessment-result',
         AssessmentResultApi.as_view(),
         name='admin_assessment_results'),
    path('upload-user-guide/',
         UserGuideUploadApi.as_view(),
         name='admin_upload_user_guide')
]
