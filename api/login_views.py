import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import User


@csrf_exempt
def login_user(request):
    if request.method == "POST":
        try:
            data = json.loads(request.body)

            email = data.get("email")
            password = data.get("password")

            user = User.objects.get(email=email, password=password)

            return JsonResponse({
                "status": "success",
                "message": "Login successful",
                "email": user.email
            })

        except User.DoesNotExist:
            return JsonResponse({
                "status": "error",
                "message": "Invalid email or password"
            })

    return JsonResponse({"message": "Invalid request"})
