import qrcode
from io import BytesIO
import base64
from django.core.mail import send_mail
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.generics import (ListCreateAPIView, ListAPIView, 
                                     RetrieveUpdateDestroyAPIView)

from accounts.models import Patient
from . models import Drug, Prescription
from . serializers import (DrugSerializer, PrescriptionSerializer, DrugPrescribedSerializer,
                           FullPrescriptionSerializer, FullDrugPrescribedSerializer)
# Create your views here.

class DrugsView(ListCreateAPIView, RetrieveUpdateDestroyAPIView):
    queryset = Drug.objects.all()
    serializer_class = DrugSerializer
    permission_classes = [IsAuthenticated]

class DrugsModView(RetrieveUpdateDestroyAPIView):
    queryset = Drug.objects.all()
    serializer_class = DrugSerializer
    permission_classes = [IsAuthenticated]

def generate_qr(prescription_id):
    qr_content = f'{prescription_id}'
    qr_image = qrcode.make(qr_content, box_size=5)
    qr_image_pil = qr_image.get_image()
    stream = BytesIO()
    qr_image.save(stream)
    qr_image_data = stream.getvalue()
    qr_image_base64 = base64.b64encode(qr_image_data).decode('utf-8')
    return qr_image_base64
    
def qrcode_email(patient, code):
    patientObj = Patient.objects.get(patient_id=patient)
    subject = 'QR Prescription'
    html_message = f"""
        <html>
            <body>
                <h3>Hello {patientObj.user.first_name}</h3>
                <p>You're receiving this email because you have been prescribed drugs at our facility.
                the below is qr_code to access the details of the prescribed drugs. \n
                scan the below code with the application.
                <b>{code}</b>
            </body>
        </html>
    """
    # html_message = render_to_string('password_reset_email.html', {'reset_code': reset_code, 'user':user})
    send_mail(subject, None, None, [patientObj.user.email], html_message=html_message)    

class PrescriptionView(ListCreateAPIView):
    queryset = Prescription.objects.all()
    serializer_class = PrescriptionSerializer
    permission_classes = [IsAuthenticated]

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
                
            prescription_instance.doctor = request.user
            prescription_instance.total = total
            prescription_instance.save()
            
            # create qrcode and send to user email
            code = generate_qr(prescription_instance.pres_id)
            qrcode_email(patient=data['patient'], code=code)

            # patient = Patient.objects.get(pk = data['patient'])
            # patient_email = patient.user.email
     
            return Response(prescription_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(prescription_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
class PrescriptionList(ListAPIView):
    queryset = Prescription.objects.all()
    serializer_class = FullPrescriptionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Prescription.objects.filter(patient = self.request.user.patient)

    def list(self, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.serializer_class(queryset, many=True)

        for prescription_data in serializer.data:
            prescription_id = prescription_data['pres_id']
            drug_prescribed_data = self.get_drugs_prescribed(prescription_id)
            prescription_data['drug_prescribed'] = drug_prescribed_data

        return Response(serializer.data)
    
    def get_drugs_prescribed(self, prescription_id):
        pres = Prescription.objects.get(pres_id=prescription_id)
        drugs_prescribed = pres.drugs_prescribed.all()
        drug_prescribed_serializer = FullDrugPrescribedSerializer(drugs_prescribed, many=True)
        return drug_prescribed_serializer.data




    # def get(self, *args, **kwargs):
    #     if not self.request.user.user_type == "patient":
    #         return Response({"error": "Unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        
    #     # try:
    #     prescriptions = Prescription.objects.filter(patient = self.request.user.patient)
    #     # prescriptions = Prescription.objects.all()
    #     print(prescriptions)
    #     serializer = self.get_serializer(prescriptions)
    #     # serializer.is_valid(raise_exception=True)
    #     return Response(serializer.data, status=status.HTTP_200_OK)
    #     # except:
    #     #     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    

