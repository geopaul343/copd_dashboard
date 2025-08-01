






class Patient {
  final String? additionalInstructions;
  final String? copdActionPlan;
  final String? copdDiagnosed;
  final String? copdStage;
  final DateTime? createdAt;
  final DateTime? dateOfBirth;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final bool? flareUpsNonHospital;
  final String? gender;
  final bool? homeOxygenCompliance;
  final bool? homeOxygenEnabled;
  final int? homeOxygenHoursPerDay;
  final double? homeOxygenLitersPerMinute;
  final int? hospitalAdditionalLast12Month;
  final bool? laennecAiStethoscope;
  final String? name;
  final bool? notificationPreferencesEnabled;
  final String? notificationPreferencesTime;
  final String? otherConditions;
  final int? pageIndex;
  final bool? pulseOximeter;
  final int? smokingDetailsCigarettesPerDay;
  final int? smokingDetailsYearsSmoked;
  final String? smokingStatus;
  final DateTime? updatedAt;
  final String? userId;
  final DateTime? vaccinationsLastUpdated;
  final String? vaccinationsReceived;
  final String? vaccinationsType;
  final bool? isUserActive; // ⭐️ NEW & nullable

  Patient({
    this.additionalInstructions,
    this.copdActionPlan,
    this.copdDiagnosed,
    this.copdStage,
    this.createdAt,
    this.dateOfBirth,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.flareUpsNonHospital,
    this.gender,
    this.homeOxygenCompliance,
    this.homeOxygenEnabled,
    this.homeOxygenHoursPerDay,
    this.homeOxygenLitersPerMinute,
    this.hospitalAdditionalLast12Month,
    this.laennecAiStethoscope,
    this.name,
    this.notificationPreferencesEnabled,
    this.notificationPreferencesTime,
    this.otherConditions,
    this.pageIndex,
    this.pulseOximeter,
    this.smokingDetailsCigarettesPerDay,
    this.smokingDetailsYearsSmoked,
    this.smokingStatus,
    this.updatedAt,
    this.userId,
    this.vaccinationsLastUpdated,
    this.vaccinationsReceived,
    this.vaccinationsType,
    this.isUserActive,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        additionalInstructions: json['additional_instructions'],
        copdActionPlan: json['copd_action_plan'],
        copdDiagnosed: json['copd_diagnosed'],
        copdStage: json['copd_stage'],
        createdAt: _parseDate(json['created_at']),
        dateOfBirth: _parseDate(json['dateofbirth']),
        emergencyContactName: json['emergency_contact_name'],
        emergencyContactPhone: json['emergency_contact_phone'],
        flareUpsNonHospital: _parseBool(json['is_flare_ups_non_hospital']),
        gender: json['gender'],
        homeOxygenCompliance: _parseBool(json['home_oxygen_compliance']),
        homeOxygenEnabled: _parseBool(json['home_oxygen_enabled']),
        homeOxygenHoursPerDay: _parseInt(json['home_oxygen_hours_per_day']),
        homeOxygenLitersPerMinute:
            _parseDouble(json['home_oxygen_liters_per_minute']),
        hospitalAdditionalLast12Month:
            _parseInt(json['hospital_admissions_last_12m']),
        laennecAiStethoscope:
            _parseBool(json['is_do_have_digital_stethoscope']),
        name: json['name'],
        notificationPreferencesEnabled:
            _parseBool(json['notification_preferences_enabled']),
        notificationPreferencesTime: json['notification_preferences_time'],
        otherConditions: json['other_conditions'],
        pageIndex: _parseInt(json['page_number']),
        pulseOximeter: _parseBool(json['do_you_have_pulse_oximeter']),
        smokingDetailsCigarettesPerDay:
            _parseInt(json['smoking_details_cigarettes_per_day']),
        smokingDetailsYearsSmoked:
            _parseInt(json['smoking_details_years_smoked']),
        smokingStatus: json['smoking_status'],
        updatedAt: _parseDate(json['updated_at']),
        userId: json['user_id'],
        vaccinationsLastUpdated: _parseDate(json['vaccinations_last_updated']),
        vaccinationsReceived: json['vaccinations_received'],
        vaccinationsType: json['vaccinations_type'],
        isUserActive: _parseBool(json['is_user_active']),
      );

  Map<String, dynamic> toJson() => {
        'additional_instructions': additionalInstructions,
        'copd_action_plan': copdActionPlan,
        'copd_diagnosed': copdDiagnosed,
        'copd_stage': copdStage,
        'created_at': createdAt?.toIso8601String(),
        'dateofbirth': dateOfBirth?.toIso8601String(),
        'emergency_contact_name': emergencyContactName,
        'emergency_contact_phone': emergencyContactPhone,
        'is_flare_ups_non_hospital': flareUpsNonHospital,
        'gender': gender,
        'home_oxygen_compliance': homeOxygenCompliance,
        'home_oxygen_enabled': homeOxygenEnabled,
        'home_oxygen_hours_per_day': homeOxygenHoursPerDay,
        'home_oxygen_liters_per_minute': homeOxygenLitersPerMinute,
        'hospital_admissions_last_12m': hospitalAdditionalLast12Month,
        'is_do_have_digital_stethoscope': laennecAiStethoscope,
        'name': name,
        'notification_preferences_enabled': notificationPreferencesEnabled,
        'notification_preferences_time': notificationPreferencesTime,
        'other_conditions': otherConditions,
        'page_number': pageIndex,
        'do_you_have_pulse_oximeter': pulseOximeter,
        'smoking_details_cigarettes_per_day': smokingDetailsCigarettesPerDay,
        'smoking_details_years_smoked': smokingDetailsYearsSmoked,
        'smoking_status': smokingStatus,
        'updated_at': updatedAt?.toIso8601String(),
        'user_id': userId,
        'vaccinations_last_updated': vaccinationsLastUpdated?.toIso8601String(),
        'vaccinations_received': vaccinationsReceived,
        'vaccinations_type': vaccinationsType,
        'is_user_active': isUserActive,
      };

  // ---------- tiny helpers ----------
  static DateTime? _parseDate(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toSftring());
  static int? _parseInt(dynamic value) =>
      value == null ? null : int.tryParse(value.toString());
  static double? _parseDouble(dynamic value) =>
      value == null ? null : double.tryParse(value.toString());
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    final str = value.toString().toLowerCase();
    return str == 'true' || str == 'yes' || str == '1';
  }
}