from rest_framework import serializers

from .models import Review


class ReviewSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(
        source="user.name",
        read_only=True,
    )

    rating = serializers.IntegerField(
        min_value=1,
        max_value=5,
    )

    class Meta:
        model = Review
        fields = (
            "id",
            "user",
            "user_name",
            "place",
            "rating",
            "comment",
            "created_at",
            "updated_at",
        )

        read_only_fields = (
            "user",
            "user_name",
            "created_at",
            "updated_at",
        )