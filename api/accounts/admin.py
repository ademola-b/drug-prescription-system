from django.contrib import admin
from .models import CustomUser, Patient

# Register your models here.
admin.site.register(CustomUser)
admin.site.register(Patient)