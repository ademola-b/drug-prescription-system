from rest_framework import serializers

from . models import Drug, DrugPrescribed, Prescription

class DrugSerializer(serializers.ModelSerializer):
    class Meta:
        model = Drug
        fields = "__all__"
