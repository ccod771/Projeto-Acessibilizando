from rest_framework import serializers

from .models import Place, PlaceAccessibility


class PlaceAccessibilitySerializer(serializers.ModelSerializer):
    characteristic_name = serializers.CharField(
        source="characteristic.name",
        read_only=True,
    )

    characteristic_type = serializers.CharField(
        source="characteristic.value_type",
        read_only=True,
    )

    level_name = serializers.CharField(
        source="value_level.name",
        read_only=True,
        allow_null=True,
    )

    class Meta:
        model = PlaceAccessibility
        fields = (
            "id",
            "characteristic",
            "characteristic_name",
            "characteristic_type",
            "value_boolean",
            "value_level",
            "level_name",
            "value_text",
            "value_number",
            "notes",
        )

    def validate(self, attrs):
        characteristic = attrs.get("characteristic")

        if characteristic is None:
            return attrs

        value_type = characteristic.value_type

        value_fields = {
            "BOOLEAN": "value_boolean",
            "LEVEL": "value_level",
            "TEXT": "value_text",
            "NUMBER": "value_number",
        }

        expected_field = value_fields.get(value_type)

        if expected_field is None:
            raise serializers.ValidationError(
                "Tipo de valor da característica inválido."
            )

        provided_fields = [
            field
            for field in value_fields.values()
            if field in attrs and attrs[field] is not None
        ]

        if len(provided_fields) != 1:
            raise serializers.ValidationError(
                "É necessário informar exatamente um valor para a característica."
            )

        if provided_fields[0] != expected_field:
            raise serializers.ValidationError(
                f"A característica '{characteristic.name}' "
                f"espera um valor do tipo '{value_type}'."
            )

        return attrs


class PlaceSerializer(serializers.ModelSerializer):
    latitude = serializers.FloatField()
    longitude = serializers.FloatField()

    average_rating = serializers.FloatField(
        read_only=True,
        allow_null=True,
    )

    review_count = serializers.IntegerField(
        read_only=True,
    )

    accessibilities = PlaceAccessibilitySerializer(
        many=True,
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
            "created_at",
            "updated_at",
        )