from rest_framework.permissions import BasePermission


class IsReviewOwner(BasePermission): #Just a permission class to check if the user is the owner of the review. This is used in the ReviewViewSet.

    def has_object_permission(
        self,
        request,
        view,
        obj,
    ):
        return obj.user == request.user