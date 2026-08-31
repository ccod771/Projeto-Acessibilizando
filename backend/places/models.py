from django.db import models

class Place(models.Model):
    
    google_place_id = models.CharField(
        max_length=255,
        unique=True
    )
    
    name = models.CharField(max_length=255)
    
    latitude = models.DecimalField(
        max_digits=9,
        decimal_places=6
    )
    
    longitude = models.DecimalField(
        max_digits=9,
        decimal_places=6
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name