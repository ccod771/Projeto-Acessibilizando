from django.db import models

from acessibility.models import AccessibilityCharacteristic


class Place(models.Model):

    google_place_id = models.CharField(
        max_length=255,
        unique=True,
    )

    name = models.CharField(
        max_length=255,
    )

    latitude = models.DecimalField(
        max_digits=9,
        decimal_places=6,
    )

    longitude = models.DecimalField(
        max_digits=9,
        decimal_places=6,
    )

    characteristics = models.ManyToManyField(
        AccessibilityCharacteristic,
        through="PlaceAccessibility",
        related_name="places",
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    updated_at = models.DateTimeField(
        auto_now=True,
    )

    def __str__(self):
        return self.name


class PlaceAccessibility(models.Model):

    place = models.ForeignKey(
        Place,
        on_delete=models.CASCADE,
        related_name="accessibilities",
    )

    characteristic = models.ForeignKey(
        AccessibilityCharacteristic,
        on_delete=models.PROTECT,
        related_name="place_accessibilities",
    )

    value_boolean = models.BooleanField(
        null=True,
        blank=True,
    )

    value_level = models.ForeignKey(
        "acessibility.AccessibilityLevel",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="place_accessibilities",
    )

    value_text = models.TextField(
        blank=True,
    )

    value_number = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        null=True,
        blank=True,
    )

    notes = models.TextField(
        blank=True,
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    updated_at = models.DateTimeField(
        auto_now=True,
    )

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=["place", "characteristic"],
                name="unique_characteristic_per_place",
            ),
        ]

        indexes = [
            models.Index(
                fields=["place"],
                name="place_access_place_idx",
            ),
            models.Index(
                fields=["characteristic"],
                name="place_access_char_idx",
            ),
        ]

    def __str__(self):
        return f"{self.place.name} - {self.characteristic.name}"