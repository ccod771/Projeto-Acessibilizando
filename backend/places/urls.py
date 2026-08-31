from django.urls import include, path

from rest_framework.routers import DefaultRouter

from .views import PlaceViewSet


router = DefaultRouter()

router.register(
    "places",
    PlaceViewSet,
    basename="place",
)


urlpatterns = [
    path("", include(router.urls)),
]