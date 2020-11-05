from django.urls import path

from api.v1.enterprise.views import (
    UserGuide, CustomerConfiguration, CustomerSummarize, RequestTracker,
    NotifyCustomer, ExtendedVsNewRequests, EnterpriseConfiguration, UserGuideUpload, EnterpriseAssessmentShareLink
)

urlpatterns = [
    path('user-guide/', UserGuide.as_view(), name="user_guide"),
    path('user-guide-upload', UserGuideUpload.as_view(), name="user_guide_upload"),
    path('customer-configuration', CustomerConfiguration.as_view(), name='customer_config_page'),
    path('customer-summarize/', CustomerSummarize.as_view(), name='customer_summarize'),
    path('request-tracker/', RequestTracker.as_view(), name='request_tracker'),
    path('notify-customer/', NotifyCustomer.as_view(), name='notify_customer'),
    path('get-extended-requests-report/', ExtendedVsNewRequests.as_view(), name='get_extended_requests_report'),
    path('consumer-request-config/', EnterpriseConfiguration.as_view(), name='enterprise_configuration'),
    path('enterprise-get-assessment-share-link/<elroi_id>', EnterpriseAssessmentShareLink.as_view(), name='enterprise_assessment_share_link'),
]
