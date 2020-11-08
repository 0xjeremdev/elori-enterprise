from django.urls import path

from api.v1.assessment.views import QuestionnaireView, AssessmentView

urlpatterns = [
    path('questionnaire/', QuestionnaireView.as_view(), name='questionnaire'),
    path('details/<elroi_id>', AssessmentView.as_view(), name='assessment_detail')
]
