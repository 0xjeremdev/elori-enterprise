from django.urls import path
from .views import (
    ConsumerRequestAPI, ConsumerRequestProgressAPI, ConsumerRequestMade
)

urlpatterns = [
    path('request', ConsumerRequestAPI.as_view(), name="consumer_request"),
    path('get-progress/<str:period>/', ConsumerRequestProgressAPI.as_view(), name="consumer_request_progress"),
    path('get-made-confirmed/', ConsumerRequestMade.as_view(), name="consumer_request_made_confirmed"),
]