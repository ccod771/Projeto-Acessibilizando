from django.db import models


class AccessibilityCategory(models.Model):
    name = models.CharField(
        max_length=100,
        unique=True
    )

    description = models.TextField(
        blank=True
    )

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    updated_at = models.DateTimeField(
        auto_now=True
    )

    class Meta:
        verbose_name = "Categoria de acessibilidade"
        verbose_name_plural = "Categorias de acessibilidade"
        ordering = ["name"]

    def __str__(self):
        return self.name


class AccessibilityCharacteristic(models.Model):
    category = models.ForeignKey(
        AccessibilityCategory,
        on_delete=models.PROTECT,
        related_name="characteristics"
    )

    name = models.CharField(
        max_length=150
    )

    description = models.TextField(
        blank=True
    )

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    updated_at = models.DateTimeField(
        auto_now=True
    )

    class Meta:
        verbose_name = "Característica de acessibilidade"
        verbose_name_plural = "Características de acessibilidade"
        ordering = ["category", "name"]

        constraints = [
            models.UniqueConstraint(
                fields=["category", "name"],
                name="unique_characteristic_per_category"
            )
        ]

    def __str__(self):
        return f"{self.category.name} - {self.name}"