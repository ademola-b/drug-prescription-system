import uuid
from django.contrib.auth.models import AbstractUser
from django.db import models

# Create your models here.
class CustomUser(AbstractUser):
    user_id = models.UUIDField(default=uuid.uuid4, unique=True, primary_key=True, editable=False)
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=15)
    image = models.ImageField(upload_to='images/', default='images/default.jpg')
    user_type = models.CharField(max_length=10, default='club', choices = [
            ('patient', 'patient'),
            ('doctor', 'doctor'),
            ('pharmacist', 'pharmacist')
        ])
    gender = models.CharField(max_length=6, default='', choices=[
        ('male', 'Male'),
        ('female', 'Female')
    ])
    address = models.TextField(blank=True)
    dob = models.DateField()

    def __str__(self):
        return f"{self.last_name} - {self.first_name}"
    
