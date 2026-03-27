-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 27, 2026 at 04:49 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `diseasedb`
--

-- --------------------------------------------------------

--
-- Table structure for table `api_activitylog`
--

CREATE TABLE `api_activitylog` (
  `id` bigint(20) NOT NULL,
  `action` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `api_appointment`
--

CREATE TABLE `api_appointment` (
  `id` bigint(20) NOT NULL,
  `appointment_date` datetime(6) NOT NULL,
  `status` varchar(20) NOT NULL,
  `notes` longtext NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `patient_id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `reminder_sent` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `api_appointment`
--

INSERT INTO `api_appointment` (`id`, `appointment_date`, `status`, `notes`, `doctor_id`, `patient_id`, `created_at`, `reminder_sent`) VALUES
(1, '2026-04-01 10:00:00.000000', 'Completed ', 'Consider ', 1, 1, '2026-03-26 08:10:28.586645', 0);

-- --------------------------------------------------------

--
-- Table structure for table `api_disease`
--

CREATE TABLE `api_disease` (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `default_severity` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `api_disease`
--

INSERT INTO `api_disease` (`id`, `name`, `default_severity`) VALUES
(1, 'Flu', 'Low'),
(3, 'Fever', 'Low'),
(4, 'Diabetes', 'Critical'),
(5, 'Cold', 'Medium'),
(6, 'Knee pains', 'Low'),
(7, 'Gastric', 'Medium');

-- --------------------------------------------------------

--
-- Table structure for table `api_notification`
--

CREATE TABLE `api_notification` (
  `id` bigint(20) NOT NULL,
  `message` longtext NOT NULL,
  `notification_type` varchar(50) NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `patient_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `api_patient`
--

CREATE TABLE `api_patient` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `address` longtext DEFAULT NULL,
  `otp` varchar(6) DEFAULT NULL,
  `otp_verified` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `api_patient`
--

INSERT INTO `api_patient` (`id`, `name`, `age`, `gender`, `phone_number`, `address`, `otp`, `otp_verified`, `created_at`, `user_id`) VALUES
(1, 'Jagadeesh ', 49, 'Male', '9440155424', 'Haliya , Nalgonda ', NULL, 0, '2026-03-25 09:57:26.565821', 1),
(3, 'Bhumika', 21, 'Female', '6300435997', 'Pidugurala', NULL, 0, '2026-03-26 08:18:59.079901', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `api_patientdisease`
--

CREATE TABLE `api_patientdisease` (
  `id` bigint(20) NOT NULL,
  `diagnosis_date` date NOT NULL,
  `severity` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL,
  `assigned_doctor` varchar(100) NOT NULL,
  `notes` longtext DEFAULT NULL,
  `disease_id` bigint(20) NOT NULL,
  `patient_id` bigint(20) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `api_patientdisease`
--

INSERT INTO `api_patientdisease` (`id`, `diagnosis_date`, `severity`, `status`, `assigned_doctor`, `notes`, `disease_id`, `patient_id`, `updated_at`) VALUES
(1, '2026-03-25', 'Low', 'Active', 'Geetha Madhuri ', '', 6, 1, '2026-03-26 09:33:34.000660'),
(3, '2026-03-26', 'Low', 'Active', 'Geetha Madhuri', 'Kindly Consider', 1, 3, '2026-03-26 08:25:54.624491');

-- --------------------------------------------------------

--
-- Table structure for table `api_usersettings`
--

CREATE TABLE `api_usersettings` (
  `id` bigint(20) NOT NULL,
  `notifications_enabled` tinyint(1) NOT NULL,
  `theme` varchar(20) NOT NULL,
  `language` varchar(20) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add disease', 7, 'add_disease'),
(26, 'Can change disease', 7, 'change_disease'),
(27, 'Can delete disease', 7, 'delete_disease'),
(28, 'Can view disease', 7, 'view_disease'),
(29, 'Can add patient', 8, 'add_patient'),
(30, 'Can change patient', 8, 'change_patient'),
(31, 'Can delete patient', 8, 'delete_patient'),
(32, 'Can view patient', 8, 'view_patient'),
(33, 'Can add patient disease', 9, 'add_patientdisease'),
(34, 'Can change patient disease', 9, 'change_patientdisease'),
(35, 'Can delete patient disease', 9, 'delete_patientdisease'),
(36, 'Can view patient disease', 9, 'view_patientdisease'),
(37, 'Can add notification', 10, 'add_notification'),
(38, 'Can change notification', 10, 'change_notification'),
(39, 'Can delete notification', 10, 'delete_notification'),
(40, 'Can view notification', 10, 'view_notification'),
(41, 'Can add user settings', 11, 'add_usersettings'),
(42, 'Can change user settings', 11, 'change_usersettings'),
(43, 'Can delete user settings', 11, 'delete_usersettings'),
(44, 'Can view user settings', 11, 'view_usersettings'),
(45, 'Can add activity log', 12, 'add_activitylog'),
(46, 'Can change activity log', 12, 'change_activitylog'),
(47, 'Can delete activity log', 12, 'delete_activitylog'),
(48, 'Can view activity log', 12, 'view_activitylog'),
(49, 'Can add appointment', 13, 'add_appointment'),
(50, 'Can change appointment', 13, 'change_appointment'),
(51, 'Can delete appointment', 13, 'delete_appointment'),
(52, 'Can view appointment', 13, 'view_appointment');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$600000$Z4ZzT1jD1mgcLE5LirY0t7$fIMxA365PpdYjnTtfpf5aDmSsg6Xvsh+vq1su4nLwzE=', NULL, 0, 'geethamadhuridoddi451@gmail.com', 'Geetha Madhuri', '', 'geethamadhuridoddi451@gmail.com', 0, 1, '2026-03-25 09:56:27.119324'),
(2, 'pbkdf2_sha256$600000$zZeH0EEhUOjwplm30oZv07$6+iKCpcoviHpNFfe0jIikJS2TxPCLXZWLEHvcug0bVE=', NULL, 0, 'doddinikki185@gmail.com', 'Doddi Nikitha ', '', 'doddinikki185@gmail.com', 0, 1, '2026-03-25 10:27:55.545464'),
(3, 'pbkdf2_sha256$600000$gbJefy6QAQwkGaUx09X0Un$h+K/1+iX3lzRTqYglAt4q2gRj+5yaEwy+8wbu57H4Ao=', NULL, 0, 'doddinikki@gmail.com', 'Madhuri ', '', 'doddinikki@gmail.com', 0, 1, '2026-03-26 08:41:37.527436');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(12, 'api', 'activitylog'),
(13, 'api', 'appointment'),
(7, 'api', 'disease'),
(10, 'api', 'notification'),
(8, 'api', 'patient'),
(9, 'api', 'patientdisease'),
(11, 'api', 'usersettings'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-03-03 05:08:41.708710'),
(2, 'auth', '0001_initial', '2026-03-03 05:08:42.255454'),
(3, 'admin', '0001_initial', '2026-03-03 05:08:42.441916'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-03-03 05:08:42.453543'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-03-03 05:08:42.464542'),
(7, 'contenttypes', '0002_remove_content_type_name', '2026-03-03 05:08:42.746133'),
(8, 'auth', '0002_alter_permission_name_max_length', '2026-03-03 05:08:42.823726'),
(9, 'auth', '0003_alter_user_email_max_length', '2026-03-03 05:08:42.837839'),
(10, 'auth', '0004_alter_user_username_opts', '2026-03-03 05:08:42.845856'),
(11, 'auth', '0005_alter_user_last_login_null', '2026-03-03 05:08:42.890141'),
(12, 'auth', '0006_require_contenttypes_0002', '2026-03-03 05:08:42.893583'),
(13, 'auth', '0007_alter_validators_add_error_messages', '2026-03-03 05:08:42.900593'),
(14, 'auth', '0008_alter_user_username_max_length', '2026-03-03 05:08:42.912864'),
(15, 'auth', '0009_alter_user_last_name_max_length', '2026-03-03 05:08:42.930661'),
(16, 'auth', '0010_alter_group_name_max_length', '2026-03-03 05:08:42.950742'),
(17, 'auth', '0011_update_proxy_permissions', '2026-03-03 05:08:42.965606'),
(18, 'auth', '0012_alter_user_first_name_max_length', '2026-03-03 05:08:42.981624'),
(19, 'sessions', '0001_initial', '2026-03-03 05:08:43.013721'),
(21, 'api', '0002_notification', '2026-03-03 06:56:43.504258'),
(22, 'api', '0003_usersettings', '2026-03-05 07:58:11.514347'),
(23, 'api', '0004_activitylog', '2026-03-17 07:54:44.380515'),
(25, 'api', '0001_initial', '2026-03-22 04:31:15.104883'),
(26, 'api', '0002_remove_patientdisease_updated_at_and_more', '2026-03-25 07:19:56.166811'),
(27, 'api', '0003_patientdisease_updated_at_and_more', '2026-03-25 08:54:29.643397'),
(28, 'api', '0004_activitylog_alter_patient_user', '2026-03-25 09:11:47.869899'),
(29, 'api', '0004_alter_usersettings_language_alter_usersettings_theme_and_more', '2026-03-26 04:44:19.447688'),
(30, 'api', '0005_appointment_created_at_appointment_reminder_sent_and_more', '2026-03-26 05:10:23.772661'),
(31, 'api', '0005_activitylog_appointment', '2026-03-26 05:16:19.979754'),
(32, 'api', '0006_activitylog_appointment_reminder_sent', '2026-03-26 08:08:18.959588');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('39oqgsjsslsgls24gu63prygj0krianu', 'eyJ1c2VyX2lkIjo3fQ:1w235l:k_5w9YfkUxoDPCscetSymfoMX7aCz82OsMZzPwrjDZE', '2026-03-30 08:14:25.646302'),
('3z7r8tri5hnzatqb5gj1iem920x1dd5e', 'eyJ1c2VyX2lkIjo2fQ:1w22mY:J5qnTxPiO67O0VHUyjAKfckKoQs3mWKHdKWPHwBAVaI', '2026-03-30 07:54:34.123129'),
('pg9nrfpzblifsu93n7eh1agiujoxw7j7', 'eyJ1c2VyX2lkIjo3fQ:1w234w:IG7S3Z3aI_Uoz5J_-OHO3Z-ixOM-e1GqLFigaDnks9U', '2026-03-30 08:13:34.344597');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `api_activitylog`
--
ALTER TABLE `api_activitylog`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_appointment`
--
ALTER TABLE `api_appointment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `api_appointment_doctor_id_b0f543eb_fk_auth_user_id` (`doctor_id`),
  ADD KEY `api_appointment_patient_id_52c787b0_fk_api_patient_id` (`patient_id`);

--
-- Indexes for table `api_disease`
--
ALTER TABLE `api_disease`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_notification`
--
ALTER TABLE `api_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `api_notification_patient_id_3a185c9f_fk_api_patient_id` (`patient_id`);

--
-- Indexes for table `api_patient`
--
ALTER TABLE `api_patient`
  ADD PRIMARY KEY (`id`),
  ADD KEY `api_patient_user_id_0944016a` (`user_id`);

--
-- Indexes for table `api_patientdisease`
--
ALTER TABLE `api_patientdisease`
  ADD PRIMARY KEY (`id`),
  ADD KEY `api_patientdisease_disease_id_253154c5_fk_api_disease_id` (`disease_id`),
  ADD KEY `api_patientdisease_patient_id_3c95aeb0_fk_api_patient_id` (`patient_id`);

--
-- Indexes for table `api_usersettings`
--
ALTER TABLE `api_usersettings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `api_activitylog`
--
ALTER TABLE `api_activitylog`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `api_appointment`
--
ALTER TABLE `api_appointment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `api_disease`
--
ALTER TABLE `api_disease`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `api_notification`
--
ALTER TABLE `api_notification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `api_patient`
--
ALTER TABLE `api_patient`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `api_patientdisease`
--
ALTER TABLE `api_patientdisease`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `api_usersettings`
--
ALTER TABLE `api_usersettings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `api_appointment`
--
ALTER TABLE `api_appointment`
  ADD CONSTRAINT `api_appointment_doctor_id_b0f543eb_fk_auth_user_id` FOREIGN KEY (`doctor_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `api_appointment_patient_id_52c787b0_fk_api_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `api_patient` (`id`);

--
-- Constraints for table `api_notification`
--
ALTER TABLE `api_notification`
  ADD CONSTRAINT `api_notification_patient_id_3a185c9f_fk_api_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `api_patient` (`id`);

--
-- Constraints for table `api_patient`
--
ALTER TABLE `api_patient`
  ADD CONSTRAINT `api_patient_user_id_0944016a_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `api_patientdisease`
--
ALTER TABLE `api_patientdisease`
  ADD CONSTRAINT `api_patientdisease_disease_id_253154c5_fk_api_disease_id` FOREIGN KEY (`disease_id`) REFERENCES `api_disease` (`id`),
  ADD CONSTRAINT `api_patientdisease_patient_id_3c95aeb0_fk_api_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `api_patient` (`id`);

--
-- Constraints for table `api_usersettings`
--
ALTER TABLE `api_usersettings`
  ADD CONSTRAINT `api_usersettings_user_id_ab925a7b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
