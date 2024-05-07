from rest_framework import serializers
from accounts.serializers import UserDetailsSerializer
from .models import Drug, DrugPrescribed, Prescription

class DrugSerializer(serializers.ModelSerializer):
    class Meta:
        model = Drug
        fields = "__all__"

class DrugPrescribedSerializer(serializers.ModelSerializer):
    # drug = DrugSerializer()
    class Meta:
        model = DrugPrescribed
        fields = "__all__"

class PrescriptionSerializer(serializers.ModelSerializer):
    drug_prescribed = DrugPrescribedSerializer(many=True)
    class Meta:
        model = Prescription
        fields = "__all__"
