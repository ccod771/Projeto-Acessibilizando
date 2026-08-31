from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.db import models


class UserManager(BaseUserManager):

    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("O usuário deve possuir um email.")

        email = self.normalize_email(email)

        user = self.model(
            email=email,
            **extra_fields
        )

        user.set_password(password)
        user.save(using=self._db)

        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        extra_fields.setdefault("is_active", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser precisa ter is_staff=True.")

        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser precisa ter is_superuser=True.")

        return self.create_user(
            email=email,
            password=password,
            **extra_fields
        )


class User(AbstractUser):
    username = None

    name = models.CharField(max_length=150)
    age = models.PositiveIntegerField()

    email = models.EmailField(unique=True)

    mobility = models.BooleanField()
    speaks = models.BooleanField()
    sensory_sensitivity = models.BooleanField()

    USERNAME_FIELD = "email"

    REQUIRED_FIELDS = [
        "name",
        "age",
        "mobility",
        "speaks",
        "sensory_sensitivity",
    ]

    objects = UserManager()

    def __str__(self):
        return self.email