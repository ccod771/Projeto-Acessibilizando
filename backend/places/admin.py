from django.contrib import admin

from .models import Place, PlaceAccessibility


class PlaceAccessibilityInline(admin.TabularInline):
    model = PlaceAccessibility
    extra = 1


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

    inlines = [
        PlaceAccessibilityInline,
    ]


@admin.register(PlaceAccessibility)
class PlaceAccessibilityAdmin(admin.ModelAdmin):
    list_display = (
        "place",
        "characteristic",
        "value",
        "created_at",
    )

    list_filter = (
        "characteristic__category",
    )

    search_fields = (
        "place__name",
        "characteristic__name",
    )