from django.urls import path

from . views import DrugsView, DrugsModView, PrescriptionView, PrescriptionList

urlpatterns = [
    path('drugs/', DrugsView.as_view(), name="drugs"),
    path('drugs/<str:pk>/', DrugsModView.as_view(), name="drugs_modify"),
    path('prescribe/', PrescriptionView.as_view(), name="prescription"),
    path('prescriptions/', PrescriptionList.as_view(), name="prescription_list"),
]
