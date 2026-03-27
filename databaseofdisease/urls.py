from django.contrib import admin
from django.urls import path, include
from django.http import HttpResponse


def home(request):
    return HttpResponse("Server Running Successfully ✅")


urlpatterns = [
    path('', home, name='home'),   # http://127.0.0.1:8000/
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),  # Connects api app
]