from django.contrib import admin

from .models import (
    AccessibilityCategory,
    AccessibilityCharacteristic,
)


@admin.register(AccessibilityCategory)
class AccessibilityCategoryAdmin(admin.ModelAdmin):
    list_display = (
        "name",
        "created_at",
        "updated_at",
    )

    search_fields = (
        "name",
    )


@admin.register(AccessibilityCharacteristic)
class AccessibilityCharacteristicAdmin(admin.ModelAdmin):
    list_display = (
        "name",
        "category",
        "created_at",
        "updated_at",
    )

    list_filter = (
        "category",
    )

    search_fields = (
        "name",
        "description",
    )

    ordering = (
        "category",
        "name",
    )