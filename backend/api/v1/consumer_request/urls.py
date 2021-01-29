from django.urls import path
from .views import (ConsumerRequestAPI, ConsumerRequestProgressAPI,
                    ConsumerRequestSetStatus, ConsumerRequestMade,
                    ConsumerReport, ConsumerRequestSend)

urlpatterns = [
    path('request', ConsumerRequestAPI.as_view(), name="consumer_request"),
    path('request/<int:enterprise_id>',
         ConsumerRequestAPI.as_view(),
         name="consumer_request_get"),
    path('request/send',
         ConsumerRequestSend.as_view(),
         name="consumer_request_complete"),
    path('set-status',
         ConsumerRequestSetStatus.as_view(),
         name="consumer_request_set_status"),
    path('report/<int:enterprise_id>',
         ConsumerReport.as_view(),
         name="consumer_report"),
    path('get-progress/<str:period>/',
         ConsumerRequestProgressAPI.as_view(),
         name="consumer_request_progress"),
    path('get-made-confirmed/',
         ConsumerRequestMade.as_view(),
         name="consumer_request_made_confirmed"),
]