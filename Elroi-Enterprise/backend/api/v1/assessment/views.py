from rest_framework import mixins, status, permissions
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response

from api.v1.accounts.models import Enterprise
from api.v1.analytics.mixins import LoggingMixin
from api.v1.assessment.models import Questionnaire, EnterpriseQuestionnaire, Answers, Assessment
from api.v1.assessment.serializers import QuestionnaireSerializer, EnterpriseQuestionnaireSerializer, \
    AssessmentSerializer


class QuestionnaireView(LoggingMixin, mixins.ListModelMixin, GenericAPIView):
    """
    Display last active questionnaire
    """
    serializer_class = QuestionnaireSerializer
    permission_classes = (permissions.IsAuthenticated,)
    queryset = Questionnaire.objects.filter(is_active=True).order_by('-id')[:1]

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        """ getting the enterprise elroi id"""
        elroi_id = request.data.get('elroi_id')
        questionnaire_id = request.data.get('questionnaire_id')
        question_id = request.data.get('question')
        answer_id = request.data.get('answer')
        try:
            enterprise = Enterprise.objects.get(elroi_id=elroi_id)
            try:
                questionnaire = Questionnaire.objects.get(id=questionnaire_id)
                try:
                    Answers.objects.get(id=answer_id, question_id=question_id)
                    e_q = EnterpriseQuestionnaire.objects.create(
                        enterprise=enterprise,
                        questionnaire=questionnaire,
                        question_id=question_id,
                        answer_id=answer_id
                    )
                    return Response(
                        EnterpriseQuestionnaireSerializer(e_q).data,
                        status=status.HTTP_201_CREATED
                    )
                except Answers.DoesNotExist:
                    return Response(
                        {"error": "Answer does not exists."},
                        status=status.HTTP_404_NOT_FOUND
                    )
            except Questionnaire.DoesNotExist:
                return Response(
                    {"error": "Questionnaire was not found"},
                    status=status.HTTP_404_NOT_FOUND
                )
        except Enterprise.DoesNotExist:
            return Response(
                {"error": "Enterprise was not found"},
                status=status.HTTP_404_NOT_FOUND
            )


class AssessmentView(LoggingMixin, GenericAPIView):
    """
    Display assessment based on questionnaire
    """
    serializer_class = AssessmentSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, elroi_id, *args, **kwargs):
        try:
            e_q = EnterpriseQuestionnaire.objects.get(enterprise__elroi_id=elroi_id)
            if e_q.is_yes:
                # get assessment assigned to the question yes answer
                assessment = Assessment.objects.get(
                    question_id=e_q.question_id,
                    answer_id=e_q.answer_id,
                    allow_enterprise=True)
                return Response(AssessmentSerializer(assessment).data, status=status.HTTP_200_OK)
            else:
                # get next questionnaire question
                questionnaire = Questionnaire.objects.filter(is_active=True
                                                             ).exclude(question_id=e_q.question_id
                                                                       ).order_by('-id')[:1]
                return Response(QuestionnaireSerializer(questionnaire).data, status=status.HTTP_200_OK)

        except EnterpriseQuestionnaire.DoesNotExist:
            return Response(
                {"error": "Data was not found"},
                status=status.HTTP_404_NOT_FOUND
            )
