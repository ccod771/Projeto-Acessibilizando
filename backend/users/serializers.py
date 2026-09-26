from django.contrib.auth import get_user_model

from rest_framework import serializers


User = get_user_model()


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User

        fields = (
            "id",
            "email",
            "name",
            "age",
            "mobility",
            "speaks",
            "sensory_sensitivity",
        )

        read_only_fields = (
            "id",
        )

    def validate_email(self, value):

        value = value.lower().strip()

        queryset = User.objects.filter(
            email=value,
        )

        if self.instance:
            queryset = queryset.exclude(
                pk=self.instance.pk,
            )

        if queryset.exists():  #Important verification in mobile app, because the user can create a user with the same email.
            raise serializers.ValidationError(
                "Este email já está cadastrado."
            )

        return value

    def validate_name(self, value):

        value = value.strip()

        if not value:
            raise serializers.ValidationError(  #Important verification in mobile app, because the user can create a user with the same email.
                "O nome é obrigatório."
            )

        return value


class RegisterSerializer(serializers.ModelSerializer):

    password = serializers.CharField(
        write_only=True,
        min_length=8,
    )

    class Meta:
        model = User

        fields = (
            "email",
            "name",
            "age",
            "mobility",
            "speaks",
            "sensory_sensitivity",
            "password",
        )

    def validate_email(self, value):

        value = value.lower().strip()

        if User.objects.filter(
            email=value,
        ).exists():
            raise serializers.ValidationError(
                "Este email já está cadastrado."
            )

        return value

    def create(self, validated_data):

        password = validated_data.pop(
            "password",
        )

        user = User.objects.create_user(
            password=password,
            **validated_data,
        )

        return user