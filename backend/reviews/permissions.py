from rest_framework.permissions import BasePermission


class IsReviewOwner(BasePermission):
    """
    Permite alterar ou excluir uma avaliação
    somente ao usuário que a criou.
    """

    def has_object_permission(
        self,
        request,
        view,
        obj,
    ):
        return obj.user == request.user