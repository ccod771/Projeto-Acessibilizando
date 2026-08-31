from django.contrib import admin
from django.urls import include, path

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)


urlpatterns = [
    path("admin/", admin.site.urls),

    # Places
    path(
        "api/",
        include("places.urls"),
    ),

    # Reviews
    path(
        "api/",
        include("reviews.urls"),
    ),

    # Users
    path(
        "api/auth/",
        include("users.urls"),
    ),

    # JWT authentication
    path(
        "api/auth/login/",
        TokenObtainPairView.as_view(),
        name="token_obtain_pair",
    ),

    path(
        "api/auth/refresh/",
        TokenRefreshView.as_view(),
        name="token_refresh",
    ),
]