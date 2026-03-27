from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Patient


class PatientSerializer(serializers.ModelSerializer):

    email = serializers.EmailField(source="user.email", read_only=True)

    class Meta:
        model = Patient
        fields = [
            "id",
            "name",
            "age",
            "gender",
            "phone_number",
            "address",
            "email",
            "created_at",
        ]


class PatientCreateSerializer(serializers.ModelSerializer):

    email = serializers.EmailField(write_only=True)
    password = serializers.CharField(write_only=True)

    class Meta:
        model = Patient
        fields = [
            "name",
            "age",
            "gender",
            "phone_number",
            "address",
            "email",
            "password",
        ]

    def create(self, validated_data):
        email = validated_data.pop("email")
        password = validated_data.pop("password")

        user = User.objects.create_user(
            username=email,
            email=email,
            password=password
        )

        patient = Patient.objects.create(user=user, **validated_data)
        return patient