from rest_framework import serializers

from .models import (
    AccessibilityCategory,
    AccessibilityCharacteristic,
    AccessibilityLevel,
)


class AccessibilityLevelSerializer(serializers.ModelSerializer):
    class Meta:
        model = AccessibilityLevel
        fields = (
            "id",
            "name",
            "description",
            "order",
        )


class AccessibilityCharacteristicSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(
        source="category.name",
        read_only=True,
    )

    class Meta:
        model = AccessibilityCharacteristic
        fields = (
            "id",
            "category",
            "category_name",
            "name",
            "description",
            "value_type",
        )


class AccessibilityCategorySerializer(serializers.ModelSerializer):
    characteristics = AccessibilityCharacteristicSerializer(
        many=True,
        read_only=True,
    )

    class Meta:
        model = AccessibilityCategory
        fields = (
            "id",
            "name",
            "description",
            "characteristics",
        )