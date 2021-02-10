from django import forms
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.forms import ReadOnlyPasswordHashField, UserChangeForm

from api.v1.accounts.models import Account


class UserCreationForm(forms.ModelForm):
    password1 = forms.CharField(label="Password", widget=forms.PasswordInput)
    password2 = forms.CharField(label="Password confirmation",
                                widget=forms.PasswordInput)

    class Meta:
        model = Account
        fields = ['email', 'username']

    def clean_password2(self):
        password1 = self.cleaned_data.get('password1')
        password2 = self.cleaned_data.get('password2')
        if password1 and password2 and password2 != password2:
            raise forms.ValidationError("Password don't match")
        return password2

    def save(self, commit=True):
        user = super().save(commit=False)
        user.set_password(self.cleaned_data['password1'])
        if commit:
            user.save()
        return user


# class UserChangeForm(forms.ModelForm):
#     # password = ReadOnlyPasswordHashField()

#     class Meta:
#         model = Account
#         fields = [
#             'email', 'username', 'password', 'is_active', 'is_admin',
#             'is_staff'
#         ]


#     def clean_password(self):
#         return self.initial['password']
class MyUserChangeForm(UserChangeForm):
    class Meta(UserChangeForm.Meta):
        model = Account
        fields = [
            'email', 'username', 'password', 'is_active', 'is_admin',
            'is_staff', 'is_verified', "is_locked"
        ]

    def save_modal(self, request, obj, form, change):
        if obj.pk == request.user.pk:
            print("equal")
        super().save(request, obj, form, change)


class AccountAdmin(UserAdmin):
    form = MyUserChangeForm
    add_form = UserCreationForm

    list_display = [
        'id', 'username', 'email', 'created_at', 'is_admin', 'is_active',
        'is_verified', "is_locked"
    ]
    search_fields = ['email', 'username']
    list_display_links = ['username']
    readonly_fields = ['created_at', 'last_login']

    filter_horizontal = []
    list_filter = []
    fieldsets = []


admin.site.register(Account, AccountAdmin)
