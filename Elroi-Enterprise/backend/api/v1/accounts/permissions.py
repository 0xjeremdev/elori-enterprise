from django.contrib.auth.models import Group
from rest_framework import permissions


def _is_in_group(user, group_name):
    """ Returns True if user is in specific group """
    try:
        return Group.objects.get(name=group_name).user_set.filter(id=user.id).exists()
    except Group.DoesNotExist:
        return None


def _has_group_permission(user, required_groups):
    return any([_is_in_group(user, group_name) for group_name in required_groups])


class HasEnterpriseViewPermission(permissions.BasePermission):
    message = "View User Guide not allowed"
    required_groups = ['enterprise']

    def has_permission(self, request, view):
        has_group_permission = _has_group_permission(request.user, self.required_groups)
        return request.user and has_group_permission
