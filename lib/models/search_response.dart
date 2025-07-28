class SearchResponse {
  final String message;
  final String? nextPageToken;
  final List<PatientUser> users;
  final String? accessToken;

  SearchResponse({
    required this.message,
    this.nextPageToken,
    required this.users,
    this.accessToken,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    try {
      List<PatientUser> users = [];

      if (json['users'] != null) {
        final usersList = json['users'] as List<dynamic>?;
        if (usersList != null) {
          for (int i = 0; i < usersList.length; i++) {
            try {
              final user = PatientUser.fromJson(usersList[i]);
              users.add(user);
            } catch (e) {
              print('❌ Error parsing user at index $i: $e');
              print('❌ User data: ${usersList[i]}');
              // Skip this user and continue with others
            }
          }
        }
      }

      return SearchResponse(
        message: json['message'] ?? '',
        nextPageToken: json['next_page_token'],
        accessToken: json['access_token'],
        users: users,
      );
    } catch (e) {
      print('❌ Error parsing SearchResponse: $e');
      print('❌ JSON data: $json');
      // Return a minimal valid SearchResponse
      return SearchResponse(
        message: json['message'] ?? 'Error parsing response',
        nextPageToken: json['next_page_token'],
        accessToken: json['access_token'],
        users: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'next_page_token': nextPageToken,
      'access_token': accessToken,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'SearchResponse(message: $message, nextPageToken: $nextPageToken, users: ${users.length}, accessToken: ${accessToken != null ? "present" : "null"})';
  }
}

class PatientUser {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? dateOfBirth;
  final String? gender;
  final Map<String, dynamic>? medicalHistory;
  final Map<String, dynamic>? vitalSigns;
  final String? lastVisit;
  final String? nextAppointment;
  final String? status;
  final bool? isUserActive;
  final String? anyRecommends;
  final String? copdActionPlan;
  final String? copdDiagnosed;
  final String? doYouHavePulseOximeter;
  final String? emergencyContactName;
  final String? fluVaccinated;
  final String? homeOxygenEnabled;
  final int? hospitalAdmissionsLast12m;
  final String? inhalerType;
  final String? isDoHaveDigitalStethoscope;
  final bool? isFlareUpsNonHospital;
  final String? otherCondition;
  final int? pageNumber;
  final String? rescuepackAtHome;
  final String? smokingStatus;
  final String? createdAt;
  final String? updatedAt;

  PatientUser({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.medicalHistory,
    this.vitalSigns,
    this.lastVisit,
    this.nextAppointment,
    this.status,
    this.isUserActive,
    this.anyRecommends,
    this.copdActionPlan,
    this.copdDiagnosed,
    this.doYouHavePulseOximeter,
    this.emergencyContactName,
    this.fluVaccinated,
    this.homeOxygenEnabled,
    this.hospitalAdmissionsLast12m,
    this.inhalerType,
    this.isDoHaveDigitalStethoscope,
    this.isFlareUpsNonHospital,
    this.otherCondition,
    this.pageNumber,
    this.rescuepackAtHome,
    this.smokingStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientUser.fromJson(Map<String, dynamic> json) {
    try {
      // Parse each field individually to identify the problematic one
      final id = json['user_id'] ?? json['id'] ?? '';
      final name = json['name'] ?? '';
      final email = json['email'];
      final phone = json['phone'];
      final address = json['address'];
      final dateOfBirth =
          json['dateofbirth'] ?? json['date_of_birth'] ?? json['dateOfBirth'];
      final gender = json['gender'];
      final medicalHistory = json['medical_history'] ?? json['medicalHistory'];
      final vitalSigns = json['vital_signs'] ?? json['vitalSigns'];
      final lastVisit = json['last_visit'] ?? json['lastVisit'];
      final nextAppointment =
          json['next_appointment'] ?? json['nextAppointment'];
      final status = json['status'];
      final isUserActive = json['is_user_active'];
      final anyRecommends = json['any_recommends'];
      final copdActionPlan = json['copd_action_plan'];
      final copdDiagnosed = json['copd_diagnosed'];
      final doYouHavePulseOximeter = json['do_you_have_pulse_oximeter'];
      final emergencyContactName = json['emergency_contact_name'];
      final fluVaccinated = json['flu_vaccinated'];
      final homeOxygenEnabled = json['home_oxygen_enabled'];
      final hospitalAdmissionsLast12m = json['hospital_admissions_last_12m'];
      final inhalerType = json['inhaler_type'];
      final isDoHaveDigitalStethoscope = json['is_do_have_digital_stethoscope'];

      // Handle boolean fields carefully
      bool? isFlareUpsNonHospital;
      try {
        isFlareUpsNonHospital = json['is_flare_ups_non_hospital'];
      } catch (e) {
        print('❌ Error parsing is_flare_ups_non_hospital: $e');
        isFlareUpsNonHospital = null;
      }

      final otherCondition = json['other_condition'];
      final pageNumber = json['page_number'];
      final rescuepackAtHome = json['rescuepack_at_home'];
      final smokingStatus = json['smoking_status'];
      final createdAt = json['created_at'];
      final updatedAt = json['updated_at'];

      return PatientUser(
        id: id,
        name: name,
        email: email,
        phone: phone,
        address: address,
        dateOfBirth: dateOfBirth,
        gender: gender,
        medicalHistory: medicalHistory,
        vitalSigns: vitalSigns,
        lastVisit: lastVisit,
        nextAppointment: nextAppointment,
        status: status,
        isUserActive: isUserActive,
        anyRecommends: anyRecommends,
        copdActionPlan: copdActionPlan,
        copdDiagnosed: copdDiagnosed,
        doYouHavePulseOximeter: doYouHavePulseOximeter,
        emergencyContactName: emergencyContactName,
        fluVaccinated: fluVaccinated,
        homeOxygenEnabled: homeOxygenEnabled,
        hospitalAdmissionsLast12m: hospitalAdmissionsLast12m,
        inhalerType: inhalerType,
        isDoHaveDigitalStethoscope: isDoHaveDigitalStethoscope,
        isFlareUpsNonHospital: isFlareUpsNonHospital,
        otherCondition: otherCondition,
        pageNumber: pageNumber,
        rescuepackAtHome: rescuepackAtHome,
        smokingStatus: smokingStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      print('❌ Error parsing PatientUser from JSON: $e');
      print('❌ JSON data: $json');
      // Return a minimal valid PatientUser object
      return PatientUser(
        id: json['user_id'] ?? json['id'] ?? 'unknown',
        name: json['name'] ?? 'Unknown Patient',
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        dateOfBirth:
            json['dateofbirth'] ?? json['date_of_birth'] ?? json['dateOfBirth'],
        gender: json['gender'],
        medicalHistory: json['medical_history'] ?? json['medicalHistory'],
        vitalSigns: json['vital_signs'] ?? json['vitalSigns'],
        lastVisit: json['last_visit'] ?? json['lastVisit'],
        nextAppointment: json['next_appointment'] ?? json['nextAppointment'],
        status: json['status'],
        isUserActive: json['is_user_active'],
        anyRecommends: json['any_recommends'],
        copdActionPlan: json['copd_action_plan'],
        copdDiagnosed: json['copd_diagnosed'],
        doYouHavePulseOximeter: json['do_you_have_pulse_oximeter'],
        emergencyContactName: json['emergency_contact_name'],
        fluVaccinated: json['flu_vaccinated'],
        homeOxygenEnabled: json['home_oxygen_enabled'],
        hospitalAdmissionsLast12m: json['hospital_admissions_last_12m'],
        inhalerType: json['inhaler_type'],
        isDoHaveDigitalStethoscope: json['is_do_have_digital_stethoscope'],
        isFlareUpsNonHospital: null, // Set to null to avoid the error
        otherCondition: json['other_condition'],
        pageNumber: json['page_number'],
        rescuepackAtHome: json['rescuepack_at_home'],
        smokingStatus: json['smoking_status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'dateofbirth': dateOfBirth,
      'gender': gender,
      'medical_history': medicalHistory,
      'vital_signs': vitalSigns,
      'last_visit': lastVisit,
      'next_appointment': nextAppointment,
      'status': status,
      'is_user_active': isUserActive,
      'any_recommends': anyRecommends,
      'copd_action_plan': copdActionPlan,
      'copd_diagnosed': copdDiagnosed,
      'do_you_have_pulse_oximeter': doYouHavePulseOximeter,
      'emergency_contact_name': emergencyContactName,
      'flu_vaccinated': fluVaccinated,
      'home_oxygen_enabled': homeOxygenEnabled,
      'hospital_admissions_last_12m': hospitalAdmissionsLast12m,
      'inhaler_type': inhalerType,
      'is_do_have_digital_stethoscope': isDoHaveDigitalStethoscope,
      'is_flare_ups_non_hospital': isFlareUpsNonHospital,
      'other_condition': otherCondition,
      'page_number': pageNumber,
      'rescuepack_at_home': rescuepackAtHome,
      'smoking_status': smokingStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'PatientUser(id: $id, name: $name, email: $email, status: $status)';
  }
}
