from django.db.models import Avg, Count
from rest_framework import viewsets

from .models import Place
from .serializers import PlaceSerializer


class PlaceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = (
        Place.objects
        .prefetch_related(
            "accessibilities__characteristic",
            "accessibilities__value_level",
        )
        .annotate(
            average_rating=Avg("reviews__rating"),
            review_count=Count("reviews"),
        )
    )

    serializer_class = PlaceSerializer