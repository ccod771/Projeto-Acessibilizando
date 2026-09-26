from django.db.models import Avg, Count

from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.filters import SearchFilter
from .models import Place
from .serializers import PlaceSerializer
from .pagination import PlacePagination

class PlaceViewSet(viewsets.ModelViewSet):
    serializer_class = PlaceSerializer
    pagination_class = PlacePagination
    filter_backends = [SearchFilter]
    search_fields = ['name']
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