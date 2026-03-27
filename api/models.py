from django.db import models
from django.contrib.auth.models import User
import random


# 1️⃣ Disease model
class Disease(models.Model):
    name = models.CharField(max_length=200)
    default_severity = models.CharField(max_length=50)

    def __str__(self):
        return self.name


# 2️⃣ Patient model (Linked with User for Login System)
class Patient(models.Model):

    # 🔐 Link with Django User model
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name="patient_profile",
        null=True,          # ✅ Added to fix migration issue
        blank=True          # ✅ Added to fix migration issue
    )

    # 👤 Basic details
    name = models.CharField(max_length=100)
    age = models.IntegerField(null=True, blank=True)
    gender = models.CharField(max_length=10, null=True, blank=True)

    phone_number = models.CharField(max_length=15, null=True, blank=True)
    address = models.TextField(null=True, blank=True)

    # 🔐 OTP fields (for registration & forgot password)
    otp = models.CharField(max_length=6, null=True, blank=True)
    otp_verified = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)

    # 🔢 Generate 6 digit OTP
    def generate_otp(self):
        self.otp = str(random.randint(100000, 999999))
        self.save()

    def __str__(self):
        return self.name if self.name else "Unnamed Patient"


# 3️⃣ PatientDisease model
class PatientDisease(models.Model):

    STATUS_CHOICES = [
        ('active', 'Active'),
        ('recovering', 'Recovering'),
        ('critical', 'Critical'),
        ('recovered', 'Recovered'),
    ]

    patient = models.ForeignKey(
        Patient,
        on_delete=models.CASCADE,
        related_name="diseases"
    )

    disease = models.ForeignKey(
        Disease,
        on_delete=models.CASCADE
    )

    diagnosis_date = models.DateField()
    severity = models.CharField(max_length=50)

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES
    )

    assigned_doctor = models.CharField(max_length=100)
    notes = models.TextField(null=True, blank=True)

    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.patient.name} - {self.disease.name}"
    
# ==============================
# 🔔 Notification Model
# ==============================
class Notification(models.Model):

    TYPE_CHOICES = [
        ("patient_added", "Patient Added"),
        ("patient_updated", "Patient Updated"),
        ("disease_added", "Disease Added"),
        ("disease_updated", "Disease Updated"),
    ]

    message = models.TextField()

    notification_type = models.CharField(
        max_length=50,
        choices=TYPE_CHOICES
    )

    is_read = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.message    
    

from django.db import models
from django.contrib.auth.models import User


class UserSettings(models.Model):

    THEME_CHOICES = [
        ('light', 'Light'),
        ('dark', 'Dark'),
        ('system', 'System Default'),
    ]

    LANGUAGE_CHOICES = [
        ('english', 'English'),
    ]

    user = models.OneToOneField(User, on_delete=models.CASCADE)

    notifications_enabled = models.BooleanField(default=True)

    theme = models.CharField(
        max_length=20,
        choices=THEME_CHOICES,
        default='system'
    )

    language = models.CharField(
        max_length=20,
        choices=LANGUAGE_CHOICES,
        default='english'
    )

    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.user.username

# ==============================
# Activity Log Model
# ==============================

class ActivityLog(models.Model):

    action = models.CharField(max_length=255)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.action      