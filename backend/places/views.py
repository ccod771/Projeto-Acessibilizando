from django.db.models import Avg, Count

from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly

from .models import Place
from .serializers import PlaceSerializer


class PlaceViewSet(viewsets.ModelViewSet):
    serializer_class = PlaceSerializer

    permission_classes = (
        IsAuthenticatedOrReadOnly,
    )

    def get_queryset(self):
        return (
            Place.objects
            .prefetch_related(
                "accessibilities__characteristic",
                "accessibilities__value_level",
                "reviews__user",
            )
            .annotate(
                average_rating=Avg(
                    "reviews__rating",
                ),
                review_count=Count(
                    "reviews",
                    distinct=True,
                ),
            )
            .order_by("name")
        )