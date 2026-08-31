from rest_framework import permissions


class IsOwnerOrReadOnly(permissions.BasePermission):
    """
    Permite leitura para qualquer usuário.
    Alteração e exclusão apenas para o proprietário do objeto.
    """

    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True

        return obj.user == request.user