from django.urls import path, include

from . views import CustomRegisterView, UpdateUserView

urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    path('register/', CustomRegisterView.as_view(), name="register"),
    path('user/update/', UpdateUserView.as_view(), name="update_user"),
]
