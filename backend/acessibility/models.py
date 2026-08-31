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

    class ValueType(models.TextChoices):
        BOOLEAN = "BOOLEAN", "Sim/Não"
        LEVEL = "LEVEL", "Nível"
        TEXT = "TEXT", "Texto"
        NUMBER = "NUMBER", "Número"

    category = models.ForeignKey(
        AccessibilityCategory,
        on_delete=models.PROTECT,
        related_name="characteristics",
    )

    name = models.CharField(
        max_length=150,
    )

    description = models.TextField(
        blank=True,
    )

    value_type = models.CharField(
        max_length=20,
        choices=ValueType.choices,
        default=ValueType.TEXT,
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    updated_at = models.DateTimeField(
        auto_now=True,
    )

    class Meta:
        verbose_name = "Característica de acessibilidade"
        verbose_name_plural = "Características de acessibilidade"
        ordering = ["category", "name"]

        constraints = [
            models.UniqueConstraint(
                fields=["category", "name"],
                name="unique_characteristic_per_category",
            )
        ]

    def __str__(self):
        return f"{self.category.name} - {self.name}"
    

class AccessibilityLevel(models.Model):
    name = models.CharField(
        max_length=50,
        unique=True,
    )

    description = models.TextField(
        blank=True,
    )

    order = models.PositiveSmallIntegerField(
        unique=True,
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    updated_at = models.DateTimeField(
        auto_now=True,
    )

    class Meta:
        verbose_name = "Nível de acessibilidade"
        verbose_name_plural = "Níveis de acessibilidade"
        ordering = ["order"]

    def __str__(self):
        return self.name