import base64
from django.contrib.auth import get_user_model
from django.core.files.storage import default_storage
import django.contrib.auth.password_validation as validators
from django.core import exceptions
from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from dj_rest_auth.serializers import (UserDetailsSerializer)
from . models import CustomUser


class CustomRegisterSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required = True, 
                                   validators= [UniqueValidator(queryset=get_user_model().objects.all(), message= 'A User with that email Already Exists')])
    
    password1 = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = [
            'username',
            'email',
            'password1',
            'password2'
        ]

    def validate(self, attrs):
        password1 = attrs.get('password1')
        password2 = attrs.get('password2')
        errors = dict()

        if password1 != password2:
            raise serializers.ValidationError({"password2": "The two password fields didn't match."})

        try:
            validators.validate_password(password=password1)
        except exceptions.ValidationError as e:
            errors['password1'] = list(e.messages)
        
        if errors:
            raise serializers.ValidationError(errors)

        return super().validate(attrs)
    
    
    def create(self, validated_data):
        user = CustomUser.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password1']
        )

        user.save()
        return user


class UserDetailsSerializer(UserDetailsSerializer):

    image_mem = serializers.SerializerMethodField("image_memory")

    class Meta(UserDetailsSerializer.Meta):
        fields = [
            'pk',
            'username',
            'email',
            'first_name',
            'last_name',
            'user_type',
            'phone',
            'gender',
            'address',
            'dob',
            'image_mem',
        ]
    
    def image_memory(request, model:CustomUser):
        if model.image.name is not None:
            with default_storage.open(model.image.name, 'rb') as loadedfile:
                return base64.b64encode(loadedfile.read())
        
class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = [
            'first_name',
            'last_name',
            'phone',
            'gender',
            'address',
            'dob'
        ]


    def update(self, instance, validated_data):
        for key, value in validated_data.items():
            setattr(instance, key, value)
        instance.save()
        return instance