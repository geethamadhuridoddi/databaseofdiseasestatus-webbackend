import json
import random

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.core.cache import cache
from django.core.mail import send_mail

from .models import Patient
from api.models import Disease


# =====================================================
# 🔐 AUTHENTICATION SECTION
# =====================================================

# ---------------- REGISTER ----------------
@csrf_exempt
@require_http_methods(["POST"])
def register_user(request):
    try:
        data = json.loads(request.body)

        full_name = data.get("full_name")
        email = data.get("email")
        password = data.get("password")
        confirm_password = data.get("confirm_password")

        if not all([full_name, email, password, confirm_password]):
            return JsonResponse({"message": "All fields are required"}, status=400)

        if password != confirm_password:
            return JsonResponse({"message": "Passwords do not match"}, status=400)

        if User.objects.filter(username=email).exists():
            return JsonResponse({"message": "Email already registered"}, status=400)

        User.objects.create_user(
            username=email,
            email=email,
            password=password,
            first_name=full_name
        )

        return JsonResponse({"message": "Registration successful"})

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


# ---------------- LOGIN ----------------
@csrf_exempt
@require_http_methods(["POST"])
def login_user(request):
    try:
        data = json.loads(request.body)

        email = data.get("email")
        password = data.get("password")

        if not email or not password:
            return JsonResponse({"message": "Email and password required"}, status=400)

        user = authenticate(username=email, password=password)

        if user is None:
            return JsonResponse({"message": "Invalid email or password"}, status=400)

        return JsonResponse({"message": "Login successful"})

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


# ---------------- FORGOT PASSWORD (SEND OTP) ----------------
@csrf_exempt
@require_http_methods(["POST"])
def forgot_password(request):
    try:
        data = json.loads(request.body)
        email = data.get("email")

        if not email:
            return JsonResponse({"message": "Email is required"}, status=400)

        if not User.objects.filter(username=email).exists():
            return JsonResponse({"message": "Email not registered"}, status=400)

        otp = str(random.randint(100000, 999999))
        cache.set(email, otp, timeout=300)  # 5 minutes

        send_mail(
            subject="Your Password Reset OTP",
            message=f"Your OTP is {otp}. It is valid for 5 minutes.",
            from_email=None,
            recipient_list=[email],
            fail_silently=False,
        )

        return JsonResponse({"message": "OTP sent successfully to your email"})

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


# ---------------- VERIFY OTP ----------------
@csrf_exempt
@require_http_methods(["POST"])
def verify_forgot_otp(request):
    try:
        data = json.loads(request.body)
        email = data.get("email")
        otp = data.get("otp")

        if not email or not otp:
            return JsonResponse({"message": "Email and OTP required"}, status=400)

        saved_otp = cache.get(email)

        if saved_otp is None:
            return JsonResponse({"message": "OTP expired"}, status=400)

        if otp != saved_otp:
            return JsonResponse({"message": "Invalid OTP"}, status=400)

        return JsonResponse({"message": "OTP verified successfully"})

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


# ---------------- RESET PASSWORD ----------------
@csrf_exempt
@require_http_methods(["POST"])
def reset_password(request):
    try:
        data = json.loads(request.body)

        email = data.get("email")
        new_password = data.get("new_password")
        confirm_password = data.get("confirm_password")

        if not all([email, new_password, confirm_password]):
            return JsonResponse({"message": "All fields required"}, status=400)

        if new_password != confirm_password:
            return JsonResponse({"message": "Passwords do not match"}, status=400)

        user = User.objects.get(username=email)
        user.set_password(new_password)
        user.save()

        cache.delete(email)

        return JsonResponse({"message": "Password reset successful"})

    except User.DoesNotExist:
        return JsonResponse({"message": "User not found"}, status=404)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


# =====================================================
# 🏥 PATIENT SECTION
# =====================================================

# ---------------- ADD PATIENT ----------------
@csrf_exempt
@require_http_methods(["POST"])
def add_patient(request):
    try:
        data = json.loads(request.body)

        name = data.get("name")
        age = data.get("age")
        gender = data.get("gender")
        phone_number = data.get("phone_number")
        address = data.get("address")

        if not all([name, age, gender, phone_number, address]):
            return JsonResponse({"message": "All fields are required"}, status=400)

        patient = Patient.objects.create(
            name=name,
            age=age,
            gender=gender,
            phone_number=phone_number,
            address=address
        )

        # 🔔 Notification
        create_notification(
            f"New patient {patient.name} added.",
            "patient_added"
        )

        return JsonResponse({
            "message": "Patient added successfully",
            "patient_id": patient.id
        })

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
@csrf_exempt
@require_http_methods(["GET"])
def patient_list(request):
    try:
        patients = Patient.objects.all()

        data = []
        for patient in patients:
            data.append({
                "id": patient.id,
                "name": patient.name,
                "age": patient.age,
                "gender": patient.gender,
                "phone_number": patient.phone_number,
                "address": patient.address,
                "created_at": patient.created_at,
            })

        return JsonResponse(data, safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)



#---------------------UPDATE PATIENT---------------------------#


@csrf_exempt
@require_http_methods(["PUT"])
def update_patient(request, patient_id):
    try:
        data = json.loads(request.body)

        patient = Patient.objects.get(id=patient_id)

        patient.name = data.get("name", patient.name)
        patient.age = data.get("age", patient.age)
        patient.gender = data.get("gender", patient.gender)
        patient.phone_number = data.get("phone_number", patient.phone_number)
        patient.address = data.get("address", patient.address)

        patient.save()

        # 🔔 Notification
        create_notification(
            f"Patient {patient.name} details updated.",
            "patient_updated"
        )

        return JsonResponse({"message": "Patient updated successfully"})

    except Patient.DoesNotExist:
        return JsonResponse({"error": "Patient not found"}, status=404)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


#---------------------DELETE PATIENT---------------------------#

@csrf_exempt
@require_http_methods(["DELETE"])
def delete_patient(request, patient_id):
    try:
        patient = Patient.objects.get(id=patient_id)
        patient_name = patient.name
        patient.delete()

        # 🔔 Notification
        create_notification(
            f"Patient {patient_name} deleted.",
            "patient_updated"
        )

        return JsonResponse({"message": "Patient deleted successfully"})

    except Patient.DoesNotExist:
        return JsonResponse({"error": "Patient not found"}, status=404)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

#---------------------ADD DISEASE---------------------------#   

@csrf_exempt
@require_http_methods(["POST"])
def add_patient_disease(request):
    try:
        data = json.loads(request.body)

        patient_id = data.get("patient_id")
        disease_name = data.get("disease_name")
        diagnosis_date = data.get("diagnosis_date")
        severity = data.get("severity")
        status = data.get("status")
        assigned_doctor = data.get("assigned_doctor")
        notes = data.get("notes")

        if not all([patient_id, disease_name, diagnosis_date, severity, status, assigned_doctor]):
            return JsonResponse({"message": "All fields are required"}, status=400)

        # Get patient
        patient = Patient.objects.get(id=patient_id)

        # Check if disease exists
        disease, created = Disease.objects.get_or_create(
            name=disease_name,
            defaults={"default_severity": severity}
        )

        # Create patient disease record
        record = PatientDisease.objects.create(
            patient=patient,
            disease=disease,
            diagnosis_date=diagnosis_date,
            severity=severity,
            status=status,
            assigned_doctor=assigned_doctor,
            notes=notes
        )

        # 🔔 Notification
        create_notification(
            f"Disease {disease.name} assigned to {patient.name}",
            "patient_disease_added"
        )

        return JsonResponse({
            "message": "Disease assigned to patient successfully",
            "record_id": record.id
        })

    except Patient.DoesNotExist:
        return JsonResponse({"error": "Patient not found"}, status=404)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

#---------------------LIST DISEASES---------------------------#
@csrf_exempt
@require_http_methods(["GET"])
def disease_list(request):
    try:
        diseases = Disease.objects.all()

        data = []
        for disease in diseases:
            data.append({
                "id": disease.id,
                "name": disease.name,
                "default_severity": disease.default_severity,
            })

        return JsonResponse(data, safe=False)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    
#---------------------UPDATE DISEASE---------------------------#    

@csrf_exempt
@require_http_methods(["PUT"])
def update_disease(request, disease_id):
    try:
        data = json.loads(request.body)

        disease = Disease.objects.get(id=disease_id)

        disease.name = data.get("name", disease.name)
        disease.default_severity = data.get("default_severity", disease.default_severity)
        disease.save()

        # 🔔 Notification
        create_notification(
            f"Disease {disease.name} updated.",
            "disease_updated"
        )

        return JsonResponse({"message": "Disease updated successfully"})

    except Disease.DoesNotExist:
        return JsonResponse({"error": "Disease not found"}, status=404)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    
#---------------------DELETE DISEASE---------------------------#   
@csrf_exempt
@require_http_methods(["DELETE"])
def delete_disease(request, disease_id):
    try:
        disease = Disease.objects.get(id=disease_id)
        disease_name = disease.name
        disease.delete()

        # 🔔 Notification
        create_notification(
            f"Disease {disease_name} deleted.",
            "disease_updated"
        )

        return JsonResponse({"message": "Disease deleted successfully"})

    except Disease.DoesNotExist:
        return JsonResponse({"error": "Disease not found"}, status=404)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


#---------------------DASHBOARD---------------------------#

from django.db.models import Count
from django.http import JsonResponse
from api.models import PatientDisease


def dashboard(request):
    total_patients = Patient.objects.count()
    total_diseases = Disease.objects.count()

    # Status summary
    status_summary = (
        PatientDisease.objects
        .values("status")
        .annotate(count=Count("id"))
    )

    # Disease summary
    disease_summary = (
        PatientDisease.objects
        .values("disease__name")
        .annotate(count=Count("id"))
    )

    return JsonResponse({
        "total_patients": total_patients,
        "total_diseases": total_diseases,
        "status_summary": list(status_summary),
        "disease_summary": list(disease_summary),
    })
from api.models import Notification
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.http import JsonResponse
import json

# ===============================
# 🔔 CREATE NOTIFICATION FUNCTION
# ===============================
def create_notification(message, notification_type):
    Notification.objects.create(
        message=message,
        notification_type=notification_type
    )

# ===============================
# 🔔 LIST ALL NOTIFICATIONS
# ===============================
@csrf_exempt
@require_http_methods(["GET"])
def notification_list(request):
    notifications = Notification.objects.all().order_by('-created_at')

    data = []
    for n in notifications:
        data.append({
            "id": n.id,
            "message": n.message,
            "type": n.notification_type,
            "is_read": n.is_read,
            "created_at": n.created_at,
        })

    return JsonResponse(data, safe=False)

# ===============================
# 🔔 MARK AS READ
# ===============================
@csrf_exempt
@require_http_methods(["PATCH"])
def mark_notification_read(request, notification_id):
    try:
        notification = Notification.objects.get(id=notification_id)
        notification.is_read = True
        notification.save()

        return JsonResponse({"message": "Notification marked as read"})

    except Notification.DoesNotExist:
        return JsonResponse({"error": "Notification not found"}, status=404)

# ===============================
# 🔔 DELETE NOTIFICATION
# ===============================
@csrf_exempt
@require_http_methods(["DELETE"])
def delete_notification(request, notification_id):
    try:
        notification = Notification.objects.get(id=notification_id)
        notification.delete()

        return JsonResponse({"message": "Notification deleted"})

    except Notification.DoesNotExist:
        return JsonResponse({"error": "Notification not found"}, status=404)

# ===============================
# 🔔 UNREAD COUNT
# ===============================
@csrf_exempt
@require_http_methods(["GET"])
def unread_notification_count(request):
    count = Notification.objects.filter(is_read=False).count()
    return JsonResponse({"unread_count": count})

# ===============================
# 🔔 ADD DISEASE TO PATIENT API
# ===============================
from .models import Patient, Disease, PatientDisease
from django.utils import timezone

@csrf_exempt
@require_http_methods(["POST"])
def assign_disease(request):
    try:
        data = json.loads(request.body)

        patient_id = data.get("patient_id")
        disease_id = data.get("disease_id")
        severity = data.get("severity")
        status = data.get("status")
        assigned_doctor = data.get("assigned_doctor")
        notes = data.get("notes")

        if not all([patient_id, disease_id, severity, status, assigned_doctor]):
            return JsonResponse({"message": "Required fields missing"}, status=400)

        patient = Patient.objects.get(id=patient_id)
        disease = Disease.objects.get(id=disease_id)

        record = PatientDisease.objects.create(
            patient=patient,
            disease=disease,
            diagnosis_date=timezone.now().date(),
            severity=severity,
            status=status,
            assigned_doctor=assigned_doctor,
            notes=notes
        )

        create_notification(
            f"Disease '{disease.name}' assigned to {patient.name}",
            "disease_assigned"
        )

        return JsonResponse({
            "message": "Disease assigned successfully",
            "record_id": record.id
        })

    except Patient.DoesNotExist:
        return JsonResponse({"error": "Patient not found"}, status=404)

    except Disease.DoesNotExist:
        return JsonResponse({"error": "Disease not found"}, status=404)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

  
# ===============================
# UPDATE PATIENT DISEASE STATUS API
# ===============================
@csrf_exempt
@require_http_methods(["PUT"])
def update_patient_disease_status(request, record_id):
    try:
        data = json.loads(request.body)

        status_value = data.get("status")
        severity = data.get("severity")

        record = PatientDisease.objects.get(id=record_id)

        if status_value:
            record.status = status_value

        if severity:
            record.severity = severity

        record.save()

        create_notification(
            f"Status updated for {record.patient.name} - {record.disease.name}",
            "status_updated"
        )

        return JsonResponse({"message": "Patient disease status updated"})

    except PatientDisease.DoesNotExist:
        return JsonResponse({"error": "Record not found"}, status=404)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
#-------------------------Return Updated Record Details------------------#  

@csrf_exempt
@require_http_methods(["PUT"])
def update_patient_disease_status(request, record_id):
    try:
        data = json.loads(request.body)

        status_value = data.get("status")
        severity = data.get("severity")

        record = PatientDisease.objects.get(id=record_id)

        if status_value:
            record.status = status_value

        if severity:
            record.severity = severity

        record.save()

        create_notification(
            f"Status updated for {record.patient.name} - {record.disease.name}",
            "status_updated"
        )

        return JsonResponse({
            "message": "Patient disease status updated",
            "patient_id": record.patient.id,
            "patient_name": record.patient.name,
            "disease": record.disease.name,
            "new_status": record.status,
            "new_severity": record.severity
        })

    except PatientDisease.DoesNotExist:
        return JsonResponse({"error": "Record not found"}, status=404)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    


import pandas as pd
from django.http import JsonResponse, HttpResponse
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from reportlab.pdfgen import canvas
from io import BytesIO

from .models import Patient, PatientDisease


# ==============================
# REPORT SUMMARY
# ==============================

@csrf_exempt
@require_http_methods(["GET"])
def report_summary(request):

    total_cases = PatientDisease.objects.count()

    recovered = PatientDisease.objects.filter(status="recovered").count()

    recovery_rate = 0
    if total_cases > 0:
        recovery_rate = round((recovered / total_cases) * 100, 2)

    return JsonResponse({
        "total_cases": total_cases,
        "recovery_rate": recovery_rate
    })


# ==============================
# PATIENT REPORT TABLE
# ==============================

@csrf_exempt
@require_http_methods(["GET"])
def patient_report(request):

    patients = Patient.objects.all()

    data = []

    for p in patients:

        disease_count = PatientDisease.objects.filter(patient=p).count()

        data.append({
            "name": p.name,
            "age": p.age,
            "diseases": disease_count
        })

    return JsonResponse(data, safe=False)


# ==============================
# DISEASE ANALYTICS
# ==============================

@csrf_exempt
@require_http_methods(["GET"])
def disease_analytics(request):

    status_data = {
        "active": PatientDisease.objects.filter(status="active").count(),
        "recovering": PatientDisease.objects.filter(status="recovering").count(),
        "recovered": PatientDisease.objects.filter(status="recovered").count(),
        "critical": PatientDisease.objects.filter(status="critical").count()
    }

    severity_data = {
        "low": PatientDisease.objects.filter(severity="Low").count(),
        "medium": PatientDisease.objects.filter(severity="Medium").count(),
        "high": PatientDisease.objects.filter(severity="High").count(),
        "critical": PatientDisease.objects.filter(severity="Critical").count()
    }

    return JsonResponse({
        "status_distribution": status_data,
        "severity_levels": severity_data
    })


# ==============================
# DOWNLOAD REPORT
# ==============================

@csrf_exempt
@require_http_methods(["GET"])
def download_report(request):

    format_type = request.GET.get("format", "csv")

    patients = Patient.objects.all()

    data = []

    for p in patients:

        disease_count = PatientDisease.objects.filter(patient=p).count()

        data.append({
            "Name": p.name,
            "Age": p.age,
            "Diseases": disease_count
        })

    df = pd.DataFrame(data)

    # CSV Export
    if format_type == "csv":

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="patient_report.csv"'

        df.to_csv(path_or_buf=response, index=False)

        return response

    # Excel Export
    elif format_type == "excel":

        response = HttpResponse(content_type='application/vnd.ms-excel')
        response['Content-Disposition'] = 'attachment; filename="patient_report.xlsx"'

        df.to_excel(response, index=False)

        return response

    # PDF Export
    elif format_type == "pdf":

        buffer = BytesIO()

        p = canvas.Canvas(buffer)

        y = 800

        p.drawString(200, y, "Patient Report")

        y -= 40

        for row in data:

            line = f"{row['Name']} | Age: {row['Age']} | Diseases: {row['Diseases']}"

            p.drawString(50, y, line)

            y -= 20

        p.save()

        buffer.seek(0)

        return HttpResponse(buffer, content_type='application/pdf')

    return JsonResponse({"error": "Invalid format"})

# =====================================================
# ⚙️ SETTINGS API
# =====================================================

from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import json

# temporary in-memory settings
app_settings = {
    "theme": "system",
    "language": "english"
}

@csrf_exempt
def get_settings(request):
    return JsonResponse(app_settings)


@csrf_exempt
def save_settings(request):
    try:
        data = json.loads(request.body)

        theme = data.get("theme")
        language = data.get("language")

        if theme:
            app_settings["theme"] = theme

        if language:
            app_settings["language"] = language

        return JsonResponse({
            "message": "Settings saved successfully",
            "settings": app_settings
        })

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


# =====================================================
# 📊 REPORTS API
# =====================================================

from django.db.models import Count
from .models import Patient, Disease, PatientDisease


def report_summary(request):

    total_patients = Patient.objects.count()
    total_diseases = Disease.objects.count()
    total_cases = PatientDisease.objects.count()

    return JsonResponse({
        "total_patients": total_patients,
        "total_diseases": total_diseases,
        "total_cases": total_cases
    })


def patient_report(request):

    patients = Patient.objects.all()

    data = []

    for p in patients:
        data.append({
            "id": p.id,
            "name": p.name,
            "age": p.age,
            "gender": p.gender,
            "phone": p.phone_number
        })

    return JsonResponse(data, safe=False)


def disease_analytics(request):

    analytics = (
        PatientDisease.objects
        .values("disease__name")
        .annotate(total=Count("id"))
    )

    return JsonResponse(list(analytics), safe=False)


def download_report(request):

    patients = Patient.objects.all()

    data = []

    for p in patients:
        data.append({
            "patient": p.name,
            "age": p.age,
            "gender": p.gender
        })

    return JsonResponse({
        "report": data
    })


# =====================================================
# 📜 ACTIVITY LOG
# =====================================================

activity_logs = []


def log_activity(message):
    activity_logs.append({
        "message": message
    })


def activity_log(request):
    return JsonResponse(activity_logs, safe=False)



# ================= PROFILE =================

from django.contrib.auth.models import User
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import json


# Get Profile
def get_profile(request):

    user = User.objects.first()

    return JsonResponse({
        "name": user.first_name,
        "role": "Doctor",
        "phone": "9876543210"
    })


# Update Profile
@csrf_exempt
def update_profile(request):

    try:
        data = json.loads(request.body)

        name = data.get("name")
        phone = data.get("phone")

        user = User.objects.first()

        user.first_name = name
        user.save()

        return JsonResponse({
            "message": "Profile updated successfully"
        })

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


# Logout
@csrf_exempt
def logout_user(request):

    return JsonResponse({
        "message": "Logged out successfully"
    })