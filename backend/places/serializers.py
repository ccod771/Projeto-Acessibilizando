from rest_framework import serializers

from reviews.models import Review

from .models import (
    Place,
    PlaceAccessibility,
)


class PlaceAccessibilitySerializer(serializers.ModelSerializer):

    characteristic = serializers.CharField(
        source="characteristic.name",
        read_only=True,
    )

    category = serializers.CharField(
        source="characteristic.category.name",
        read_only=True,
    )

    level = serializers.CharField(
        source="value_level.name",
        read_only=True,
    )

    class Meta:
        model = PlaceAccessibility

        fields = (
            "id",
            "characteristic",
            "category",
            "value_boolean",
            "level",
            "value_text",
            "value_number",
            "notes",
        )

        read_only_fields = (
            "id",
            "characteristic",
            "category",
            "level",
        )


class PlaceReviewSerializer(serializers.ModelSerializer):

    user = serializers.CharField(
        source="user.name",
        read_only=True,
    )

    class Meta:
        model = Review

        fields = (
            "id",
            "user",
            "rating",
            "comment",
            "created_at",
            "updated_at",
        )

        read_only_fields = (
            "id",
            "user",
            "created_at",
            "updated_at",
        )


class PlaceSerializer(serializers.ModelSerializer):

    accessibilities = PlaceAccessibilitySerializer(
        many=True,
        read_only=True,
    )

    reviews = PlaceReviewSerializer(
        many=True,
        read_only=True,
    )

    average_rating = serializers.FloatField(
        read_only=True,
    )

    review_count = serializers.IntegerField(
        read_only=True,
    )

    class Meta:
        model = Place

        fields = (
            "id",
            "google_place_id",
            "name",
            "latitude",
            "longitude",
            "average_rating",
            "review_count",
            "accessibilities",
            "reviews",
            "created_at",
            "updated_at",
        )

        read_only_fields = (
            "id",
            "average_rating",
            "review_count",
            "accessibilities",
            "reviews",
            "created_at",
            "updated_at",
        )