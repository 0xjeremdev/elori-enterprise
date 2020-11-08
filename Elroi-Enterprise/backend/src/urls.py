from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include
from drf_yasg import openapi
from drf_yasg.views import get_schema_view
from rest_framework import permissions

schema_view = get_schema_view(
    openapi.Info(
        title="Elroi API",
        default_version='v1',
        description="Elroi project API description",
        terms_of_service="",
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)

urlpatterns = [
    path('api/v1/', include('api.v1.accounts.urls')),
    path('api/v1/enterprise/', include('api.v1.enterprise.urls')),
    path('api/v1/consumer/', include('api.v1.consumer_request.urls')),
    path('api/v1/assessment/', include('api.v1.assessment.urls')),
    path('api/v1/admin/', include('api.v1.elroi_admin.urls')),
    path('', schema_view.with_ui('swagger', cache_timeout=0), name='schema_swagger_ui'),
    path('api/api.json/', schema_view.without_ui(cache_timeout=0), name='schema_json'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema_redoc'),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)