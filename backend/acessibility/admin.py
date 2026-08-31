from django.contrib import admin

from .models import (
    AccessibilityCategory,
    AccessibilityCharacteristic,
    AccessibilityLevel,
)


@admin.register(AccessibilityLevel)
class AccessibilityLevelAdmin(admin.ModelAdmin):
    list_display = (
        "name",
        "order",
        "created_at",
    )

    search_fields = (
        "name",
    )

    ordering = (
        "order",
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

    ordering = (
        "name",
    )


@admin.register(AccessibilityCharacteristic)
class AccessibilityCharacteristicAdmin(admin.ModelAdmin):
    list_display = (
        "name",
        "category",
        "value_type",
        "created_at",
        "updated_at",
    )

    list_filter = (
        "category",
        "value_type",
    )

    search_fields = (
        "name",
        "description",
    )

    ordering = (
        "category",
        "name",
    )