from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import generics, status

from . models import CustomUser
from . serializers import CustomRegisterSerializer
# Create your views here.
class CustomRegisterView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomRegisterSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = self.perform_create(serializer)
        return Response(serializer.data, status=status.HTTP_201_CREATED)