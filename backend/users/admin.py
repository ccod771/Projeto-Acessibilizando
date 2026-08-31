from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import User


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    model = User

    list_display = (
        "email",
        "name",
        "age",
        "mobility",
        "speaks",
        "sensory_sensitivity",
        "is_staff",
        "is_active",
    )

    list_filter = (
        "mobility",
        "speaks",
        "sensory_sensitivity",
        "is_staff",
        "is_active",
    )

    search_fields = (
        "email",
        "name",
    )

    ordering = ("email",)

    fieldsets = (
        (None, {"fields": ("email", "password")}),
        (
            "Informações pessoais",
            {
                "fields": (
                    "name",
                    "age",
                    "mobility",
                    "speaks",
                    "sensory_sensitivity",
                )
            },
        ),
        (
            "Permissões",
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "groups",
                    "user_permissions",
                )
            },
        ),
        ("Datas importantes", {"fields": ("last_login", "date_joined")}),
    )

    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "email",
                    "name",
                    "age",
                    "mobility",
                    "speaks",
                    "sensory_sensitivity",
                    "password1",
                    "password2",
                    "is_staff",
                    "is_active",
                ),
            },
        ),
    )