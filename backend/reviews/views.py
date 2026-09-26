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

        queryset = (
            Review.objects
            .select_related(
                "user",
                "place",
            )
            .order_by("-created_at")
        )

        place_id = self.request.query_params.get("place")

        if place_id:
            queryset = queryset.filter(
                place_id=place_id,
            )

        return queryset

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