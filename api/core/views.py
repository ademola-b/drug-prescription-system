from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView

from . models import Drug, Prescription, DrugPrescribed
from . serializers import DrugSerializer, PrescriptionSerializer, DrugPrescribedSerializer
# Create your views here.

class DrugsView(ListCreateAPIView, RetrieveUpdateDestroyAPIView):
    queryset = Drug.objects.all()
    serializer_class = DrugSerializer
    permission_classes = [IsAuthenticated]

class DrugsModView(RetrieveUpdateDestroyAPIView):
    queryset = Drug.objects.all()
    serializer_class = DrugSerializer
    permission_classes = [IsAuthenticated]

class PrescriptionView(ListCreateAPIView):
    queryset = Prescription.objects.all()
    serializer_class = PrescriptionSerializer

    def post(self, request):
        data = request.data
        # extract drug_prescribed_data
        drug_pres_data = data.pop('drug_prescribed', [])
        print(f"data now: {data}")
        print(f"drug_pre: {drug_pres_data}")
        prescription_serializer = PrescriptionSerializer(data=data)
        if prescription_serializer.is_valid():
            prescription_instance = prescription_serializer.save(total=0.0)

            total = 0.0
            for dp_data in drug_pres_data:
                dp_data['prescription'] = prescription_instance.pk
                dp_serializer = DrugPrescribedSerializer(data=dp_data)
                if dp_serializer.is_valid():
                    dp_instance = dp_serializer.save()
                    total += dp_instance.total
                else:
                    return Response(dp_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
                
                prescription_instance.total = total
                prescription_instance.save()
            
            # create qrcode and send to user email
            
            
            return Response(prescription_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(prescription_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

