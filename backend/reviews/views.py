from rest_framework import viewsets
from rest_framework.permissions import (
    IsAuthenticated,
    IsAuthenticatedOrReadOnly,
)

from .models import Review
from .serializers import ReviewSerializer


class ReviewViewSet(viewsets.ModelViewSet):
    serializer_class = ReviewSerializer

    def get_queryset(self):
        return (
            Review.objects
            .select_related(
                "user",
                "place",
            )
            .order_by("-created_at")
        )

    def get_permissions(self):
        if self.action in (
            "list",
            "retrieve",
        ):
            return [
                IsAuthenticatedOrReadOnly(),
            ]

        return [
            IsAuthenticated(),
        ]

    def perform_create(self, serializer):
        serializer.save(
            user=self.request.user,
        )