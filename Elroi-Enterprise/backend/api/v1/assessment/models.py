import hashlib
import random

from django.db import models

from api.v1.accounts.models import Enterprise, Account


class Questions(models.Model):
    parent_id = models.PositiveIntegerField(default=0)
    question = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.question

    class Meta:
        db_table = 'questionnaires_questions'
        ordering = ['-created_at']

class Answers(models.Model):
    question = models.ForeignKey(Questions, on_delete=models.CASCADE)
    answer = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.question.question} - {self.answer}'

    class Meta:
        db_table = 'questionnaires_answers'
        ordering = ['-created_at']

class Questionnaire(models.Model):
    title = models.CharField(max_length=255)
    question = models.ForeignKey(Questions, on_delete=models.CASCADE)
    is_active = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = 'questionnaires'
        ordering = ['-created_at']

class EnterpriseQuestionnaire(models.Model):
    enterprise = models.ForeignKey(Enterprise, on_delete=models.CASCADE)
    questionnaire = models.ForeignKey(Questionnaire, on_delete=models.CASCADE)
    question = models.ForeignKey(Questions, on_delete=models.CASCADE)
    answer = models.ForeignKey(Answers, on_delete=models.CASCADE)
    is_yes = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.enterprise.elroi_id} - {self.questionnaire.title}'

    class Meta:
        db_table = 'enterprise_questionnaires'
        ordering = ['-created_at']

class Assessment(models.Model):
    title = models.CharField(max_length=255)
    question = models.ForeignKey(Questions, on_delete=models.SET_NULL, blank=True, null=True)
    answer = models.ForeignKey(Answers, on_delete=models.SET_NULL, blank=True, null=True)
    allow_enterprise = models.BooleanField(default=False)
    allow_elroi_user = models.BooleanField(default=False)
    share_hash = models.CharField(max_length=255)
    created_by = models.ForeignKey(Account, on_delete=models.SET_NULL, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        self.share_hash = hashlib.sha256(str(random.getrandbits(256)).encode('utf-8')).hexdigest()
        super(Assessment, self).save(*args, **kwargs)

    class Meta:
        db_table = 'assessments'
        ordering = ['-created_at']

class AssessmentQuestions(models.Model):
    assessment = models.ForeignKey(Assessment, on_delete=models.CASCADE)
    question = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.question

    class Meta:
        db_table = 'assessments_questions'
        ordering = ['-created_at']

class AssessmentQuestionAnswers(models.Model):
    question = models.ForeignKey(AssessmentQuestions, on_delete=models.CASCADE)
    answer = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.answer

    class Meta:
        db_table = 'assessments_questions_answers'
        ordering = ['-created_at']

class AssessmentResults(models.Model):
    assessment = models.ForeignKey(Assessment, on_delete=models.CASCADE)
    question = models.ForeignKey(AssessmentQuestions, on_delete=models.CASCADE)
    answer = models.ForeignKey(AssessmentQuestionAnswers, on_delete=models.CASCADE)
    additional_answer = models.CharField(max_length=255, null=True, blank=True)
    enterprise_id = models.ForeignKey(Enterprise, on_delete=models.SET_NULL, null=True, blank=True)
    user_id = models.ForeignKey(Account, on_delete=models.SET_NULL, max_length=9, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.assessment_id.title

    class Meta:
        db_table = 'assessment_results'
        ordering = ['-created_at']
