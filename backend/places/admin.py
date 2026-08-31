from django.contrib import admin

from .models import Place


@admin.register(Place)
class PlaceAdmin(admin.ModelAdmin):
    list_display = (
        "name",
        "google_place_id",
        "latitude",
        "longitude",
        "created_at",
    )

    search_fields = (
        "name",
        "google_place_id",
    )

    ordering = ("name",)