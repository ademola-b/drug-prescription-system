import uuid
from django.contrib.auth import get_user_model
from django.contrib.auth.models import AbstractUser
from django.db import models

from rest_framework.validators import UniqueValidator

# Create your models here.
class CustomUser(AbstractUser):
    user_id = models.UUIDField(default=uuid.uuid4, unique=True, primary_key=True, editable=False)
    email = models.EmailField(unique=True, 
                            #    validators= [UniqueValidator(queryset=get_user_model().objects.all(), message="A user with that email already exists.")] ,
                             )
    phone = models.CharField(max_length=15)
    image = models.ImageField(upload_to='images/', default='default.jpg')
    user_type = models.CharField(max_length=10, default='patient', choices = [
            ('patient', 'patient'),
            ('doctor', 'doctor'),
            ('pharmacist', 'pharmacist')
        ])
    gender = models.CharField(max_length=6, default='', choices=[
        ('male', 'Male'),
        ('female', 'Female')
    ])
    address = models.TextField(blank=True)
    dob = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"{self.username}"
    
