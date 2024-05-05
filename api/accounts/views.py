from django.shortcuts import render
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import generics, status
from rest_framework.authtoken.models import Token


from . models import CustomUser, Patient
from . serializers import CustomRegisterSerializer, PatientUpdateSerializer, UserDetailsSerializer
# Create your views here.
class CustomRegisterView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomRegisterSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = self.perform_create(serializer)
        # token = Token.objects.get_or_create(user=user)
        # serializer.validated_data["token"] = token.key
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
class UpdateUserView(generics.UpdateAPIView):
    serializer_class = PatientUpdateSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        try:
            return self.request.user.patient
        except:
            user = self.request.user
            patient = Patient.objects.create(user=user)
            return patient
    
class RetrieveUserDetail(generics.RetrieveAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = UserDetailsSerializer
    permission_classes = [IsAuthenticated]

    def get(self, *args, **kwargs):
        username = self.kwargs.get('username')
        try:
            user = CustomUser.objects.get(username=username)
            serializer = self.get_serializer(user)
            return Response(serializer.data)
        except:
            return Response({"error": "Not Record found"}, status=status.HTTP_404_NOT_FOUND)
        

