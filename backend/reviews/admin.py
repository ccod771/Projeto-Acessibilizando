from django.contrib import admin

from .models import Review


@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = (
        "user",
        "place",
        "rating",
        "created_at",
        "updated_at",
    )

    list_filter = (
        "rating",
        "created_at",
    )

    search_fields = (
        "user__email",
        "user__name",
        "place__name",
        "comment",
    )

    ordering = (
        "-created_at",
    )