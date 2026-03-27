from django.urls import path
from .views import (

    # Auth
    register_user,
    login_user,
    forgot_password,
    verify_forgot_otp,
    reset_password,

    # Patients
    add_patient,
    patient_list,
    update_patient,
    delete_patient,

    # Diseases
    disease_list,
    update_disease,
    delete_disease,

    # Patient Disease
    add_patient_disease,
    assign_disease,
    update_patient_disease_status,

    # Dashboard
    dashboard,

    # Notifications
    notification_list,
    mark_notification_read,
    delete_notification,
    unread_notification_count,
    
    # Reports  
    report_summary,
    patient_report,
    disease_analytics,
    download_report,

     # Settings
    get_settings,
    save_settings,

    # Activity Log
    activity_log,

    # Profile
    get_profile,
    update_profile,
    logout_user,
)

urlpatterns = [

    # ================= AUTH =================
    path('register/', register_user),
    path('login/', login_user),
    path('forgot-password/', forgot_password),
    path('verify-forgot-otp/', verify_forgot_otp),
    path('reset-password/', reset_password),

    # ================= PATIENT =================
    path('patients/add/', add_patient),
    path('patients/', patient_list),
    path('patients/<int:patient_id>/update/', update_patient),
    path('patients/<int:patient_id>/delete/', delete_patient),

    # ================= DISEASE =================
    path('patients/add-disease/', add_patient_disease),
    path('diseases/', disease_list),
    path('diseases/<int:disease_id>/update/', update_disease),
    path('diseases/<int:disease_id>/delete/', delete_disease),

    # ================= ASSIGN DISEASE =================
    path('patients/assign-disease/', assign_disease),

    # ================= UPDATE STATUS =================
    path('patients/disease/<int:record_id>/update/', update_patient_disease_status),

    # ================= DASHBOARD =================
    path('dashboard/', dashboard),

    # ================= NOTIFICATIONS =================
    path('notifications/', notification_list),
    path('notifications/unread-count/', unread_notification_count),
    path('notifications/<int:notification_id>/read/', mark_notification_read),
    path('notifications/<int:notification_id>/delete/', delete_notification),

    # Reports
    path('reports/summary/', report_summary),
    path('reports/patients/', patient_report),
    path('reports/analytics/', disease_analytics),
    path('reports/download/', download_report), 


    # SETTINGS
    path('settings/', get_settings),
    path('settings/save/', save_settings), 
    path('activity-log/', activity_log), 


    # PROFILE
    path('profile/', get_profile),
    path('profile/update/', update_profile),
    path('logout/', logout_user),                                                                                              
]