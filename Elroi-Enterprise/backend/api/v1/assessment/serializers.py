from rest_framework import serializers

from api.v1.assessment.models import EnterpriseQuestionnaire, Questionnaire, Answers, Assessment, AssessmentResults


class QuestionnaireSerializer(serializers.ModelSerializer):
    question = serializers.PrimaryKeyRelatedField(read_only=True)
    answers = serializers.SerializerMethodField()

    def get_answers(self, obj):
        answers = Answers.objects.filter(question_id=obj.id)
        return answers

    class Meta:
        model = Questionnaire
        fields = ['title', 'question', 'answers', 'is_active']

class EnterpriseQuestionnaireSerializer(serializers.ModelSerializer):
    elroi_id = serializers.SerializerMethodField()
    questionnaire = serializers.PrimaryKeyRelatedField(read_only=True)
    question = serializers.PrimaryKeyRelatedField(read_only=True)
    answer = serializers.PrimaryKeyRelatedField(read_only=True)

    def get_elroi_id(self, obj):
        return obj.enterprise.elroi_id

    class Meta:
        model = EnterpriseQuestionnaire
        fields = ['elroi_id', 'questionnaire', 'question', 'answer']

class AnswersSerializer(serializers.ModelSerializer):
    question = serializers.PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = Answers
        fields = ['question', 'answer']

class AssessmentSerializer(serializers.ModelSerializer):
    question = serializers.PrimaryKeyRelatedField(read_only=True)
    answer = serializers.PrimaryKeyRelatedField(read_only=True)
    title = serializers.CharField(max_length=255)
    allow_enterprise = serializers.BooleanField(default=False)
    allow_elroi_user = serializers.BooleanField(default=False)
    share_hash = serializers.CharField(max_length=255, read_only=True)
    created_by = serializers.HiddenField(default=serializers.CurrentUserDefault())

    class Meta:
        model = Assessment
        fields = ['title', 'question', 'answer', 'title', 'allow_enterprise', 'allow_elroi_user', 'share_hash', 'created_by']

class AssessmentResultSerializer(serializers.ModelSerializer):
    assessment = serializers.PrimaryKeyRelatedField(read_only=True)
    question = serializers.PrimaryKeyRelatedField(read_only=True)
    answer = serializers.PrimaryKeyRelatedField(read_only=True)
    additional_answer = serializers.CharField(max_length=255, read_only=True)
    enterprise_id = serializers.PrimaryKeyRelatedField(read_only=True)
    user_id = serializers.PrimaryKeyRelatedField(read_only=True)
    created_at = serializers.DateTimeField(read_only=True)

    class Meta:
        model = AssessmentResults
        fields = ['assessment', 'question', 'answer', 'additional_answer', 'enterprise_id', 'user_id', 'created_at']