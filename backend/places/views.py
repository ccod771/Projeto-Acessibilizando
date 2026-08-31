from rest_framework import viewsets

from .models import Place
from .serializers import PlaceSerializer


class PlaceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Place.objects.prefetch_related(
        "accessibilities__characteristic",
        "accessibilities__value_level",
    ).all()

    serializer_class = PlaceSerializer