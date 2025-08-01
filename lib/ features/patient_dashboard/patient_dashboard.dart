import 'dart:convert';

import 'package:copd_clinical_dashbord/core/widgets/daily_check_screen.dart';
import 'package:copd_clinical_dashbord/core/widgets/monthly_check_screen.dart';
import 'package:copd_clinical_dashbord/core/widgets/weekly_check_screen.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../patient_search/models/search_response.dart';
import '../auth/auth_screen_mobile.dart';

class PatientDashboard extends StatefulWidget {
  final PatientUser patient;
 

   const PatientDashboard({super.key, required this.patient});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      _buildUserDashboard(),
      DailyCheckScreen(
        patientId: widget.patient.id,
        patientName: widget.patient.name,
      ),
      WeeklyCheckScreen(
        patientId: widget.patient.id,
        patientName: widget.patient.name,
      ),
      MonthlyCheckScreen(
        patientId: widget.patient.id,
        patientName: widget.patient.name,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        elevation: 8,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Daily',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.view_week), label: 'Weekly'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Monthly',
          ),
        ],
      ),
    );
  }

  Widget _buildUserDashboard() {
    // Debug logging to see what data we have
    print('🔍 Patient Dashboard - Raw patient data:');
    print('🔍 Name: ${widget.patient.name}');
    print('🔍 ID: ${widget.patient.id}');
    print('🔍 Date of Birth: ${widget.patient.dateOfBirth}');
    print('🔍 Gender: ${widget.patient.gender}');
    print('🔍 Email: ${widget.patient.email}');
    print('🔍 Phone: ${widget.patient.phone}');
    print('🔍 Address: ${widget.patient.address}');
    print('🔍 COPD Diagnosed: ${widget.patient.copdDiagnosed}');
    print('🔍 COPD Action Plan: ${widget.patient.copdActionPlan}');
    print(
      '🔍 Hospital Admissions: ${widget.patient.hospitalAdmissionsLast12m}',
    );
    print('🔍 Any Recommends: ${widget.patient.anyRecommends}');
    print('🔍 Emergency Contact: ${widget.patient.emergencyContactName}');
    print('🔍 Flu Vaccinated: ${widget.patient.fluVaccinated}');
    print('🔍 Home Oxygen: ${widget.patient.homeOxygenEnabled}');
    print('🔍 Inhaler Type: ${widget.patient.inhalerType}');
    print('🔍 Smoking Status: ${widget.patient.smokingStatus}');
    print('🔍 Other Condition: ${widget.patient.otherCondition}');
    print('🔍 Stethoscope: ${widget.patient.isDoHaveDigitalStethoscope}');
    print('🔍 Pulse Oximeter: ${widget.patient.doYouHavePulseOximeter}');
    print('🔍 Rescue Pack: ${widget.patient.rescuepackAtHome}');
    print('🔍 Flare Ups: ${widget.patient.isFlareUpsNonHospital}');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Patient Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Professional Header Section
            _buildProfessionalHeader(),

            // Quick Stats Cards
            _buildQuickStatsSection(),

            // Patient Demographics
            _buildPatientDemographicsSection(),

            // COPD Assessment
            _buildCOPDAssessmentSection(),

            // Medical Equipment & Monitoring
            _buildMedicalEquipmentSection(),

            // Medications & Treatment
            _buildMedicationsSection(),

            // Emergency Information
            _buildEmergencySection(),

            // Vaccination & Prevention
            _buildVaccinationSection(),

            // Lifestyle & Risk Factors
            _buildLifestyleSection(),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Patient Avatar with Medical Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.person, size: 40, color: Colors.blue.shade700),
            ),
            SizedBox(height: 16),

            // Patient Name
            Text(
              widget.patient.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),

            // Patient ID
            Text(
              'Patient ID: ${widget.patient.id}',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            SizedBox(height: 8),

            // Status Badge
            if (widget.patient.isUserActive != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      widget.patient.isUserActive!
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        widget.patient.isUserActive!
                            ? Colors.green
                            : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.patient.isUserActive! ? 'Active Patient' : 'Inactive',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        widget.patient.isUserActive!
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Hospital Admissions',
                  '${widget.patient.hospitalAdmissionsLast12m ?? 0}',
                  'Last 12 months',
                  Icons.local_hospital,
                  Colors.red.shade100,
                  Colors.red.shade700,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'COPD Stage',
                  _getCOPDStage(),
                  'Current Stage',
                  Icons.medical_services,
                  Colors.orange.shade100,
                  Colors.orange.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDemographicsSection() {
    return _buildSection('Patient Demographics', Icons.person, [
      if (widget.patient.dateOfBirth != null)
        _buildInfoRow('Date of Birth', widget.patient.dateOfBirth!),
      if (widget.patient.gender != null)
        _buildInfoRow('Gender', widget.patient.gender!),
      if (widget.patient.email != null)
        _buildInfoRow('Email', widget.patient.email!),
      if (widget.patient.phone != null)
        _buildInfoRow('Phone', widget.patient.phone!),
      if (widget.patient.address != null)
        _buildInfoRow('Address', widget.patient.address!),
    ]);
  }

  Widget _buildCOPDAssessmentSection() {
    List<Widget> assessmentItems = [];

    final copdDiagnosis = _getCOPDDiagnosis();
    if (copdDiagnosis != 'Not specified') {
      assessmentItems.add(_buildInfoRow('COPD Diagnosed', copdDiagnosis));
    }

    final copdStage = _getCOPDStage();
    if (copdStage != 'Not specified') {
      assessmentItems.add(_buildInfoRow('COPD Stage', copdStage));
    }

    final actionPlan = _getActionPlanStatus();
    if (actionPlan != 'Not specified') {
      assessmentItems.add(_buildInfoRow('Action Plan', actionPlan));
    }

    if (assessmentItems.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildSection(
      'COPD Assessment',
      Icons.medical_services,
      assessmentItems,
    );
  }

  Widget _buildMedicalEquipmentSection() {
    List<Widget> equipmentItems = [];

    final pulseOximeter = _getPulseOximeterStatus();
    if (pulseOximeter != 'Not specified') {
      equipmentItems.add(_buildInfoRow('Pulse Oximeter', pulseOximeter));
    }

    final homeOxygen = _getHomeOxygenStatus();
    if (homeOxygen != 'Not specified') {
      equipmentItems.add(_buildInfoRow('Home Oxygen', homeOxygen));
    }

    if (widget.patient.isDoHaveDigitalStethoscope != null) {
      equipmentItems.add(
        _buildInfoRow(
          'Digital Stethoscope',
          widget.patient.isDoHaveDigitalStethoscope!,
        ),
      );
    }

    if (equipmentItems.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildSection(
      'Medical Equipment & Monitoring',
      Icons.monitor_heart,
      equipmentItems,
    );
  }

  Widget _buildMedicationsSection() {
    List<Widget> medicationItems = [];

    final inhaler = _getInhalerInfo();
    if (inhaler != 'Not specified') {
      medicationItems.add(_buildInfoRow('Inhaler Type', inhaler));
    }

    final rescuePack = _getRescuePackStatus();
    if (rescuePack != 'Not specified') {
      medicationItems.add(_buildInfoRow('Rescue Pack', rescuePack));
    }

    if (widget.patient.anyRecommends != null) {
      medicationItems.add(
        _buildInfoRow('Recommendations', widget.patient.anyRecommends!),
      );
    }

    if (medicationItems.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildSection(
      'Medications & Treatment',
      Icons.medication,
      medicationItems,
    );
  }

  Widget _buildEmergencySection() {
    final emergencyContact = _getEmergencyContact();
    if (emergencyContact == 'Not specified') {
      return SizedBox.shrink();
    }

    return _buildSection('Emergency Information', Icons.emergency, [
      _buildInfoRow('Emergency Contact', emergencyContact),
    ]);
  }

  Widget _buildVaccinationSection() {
    final vaccination = _getVaccinationStatus();
    if (vaccination == 'Not specified') {
      return SizedBox.shrink();
    }

    return _buildSection('Vaccination & Prevention', Icons.vaccines, [
      _buildInfoRow('Flu Vaccination', vaccination),
    ]);
  }

  Widget _buildLifestyleSection() {
    List<Widget> lifestyleItems = [];

    final smokingStatus = _getSmokingStatus();
    if (smokingStatus != 'Not specified') {
      lifestyleItems.add(_buildInfoRow('Smoking Status', smokingStatus));
    }

    final otherConditions = _getOtherConditions();
    if (otherConditions != 'Not specified') {
      lifestyleItems.add(_buildInfoRow('Other Conditions', otherConditions));
    }

    if (lifestyleItems.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildSection(
      'Lifestyle & Risk Factors',
      Icons.smoking_rooms,
      lifestyleItems,
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade700, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods to parse JSON data
  String _getCOPDDiagnosis() {
    try {
      if (widget.patient.copdDiagnosed != null) {
        print('🔍 COPD Diagnosed raw data: ${widget.patient.copdDiagnosed}');
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.copdDiagnosed!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 COPD Diagnosed parsed: $data');
        return data['hasCOPD'] == true ? 'Yes' : 'No';
      }
    } catch (e) {
      print('Error parsing COPD diagnosis: $e');
    }
    return 'Not specified';
  }

  String _getCOPDStage() {
    try {
      if (widget.patient.copdDiagnosed != null) {
        print('🔍 COPD Stage raw data: ${widget.patient.copdDiagnosed}');
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.copdDiagnosed!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 COPD Stage parsed: $data');
        return data['copdStage'] ?? 'Not specified';
      }
    } catch (e) {
      print('Error parsing COPD stage: $e');
    }
    return 'Not specified';
  }

  String _getActionPlanStatus() {
    try {
      if (widget.patient.copdActionPlan != null) {
        print('🔍 Action Plan raw data: ${widget.patient.copdActionPlan}');
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.copdActionPlan!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 Action Plan parsed: $data');
        return data['hasCOPDActionPlan'] == true
            ? 'Available'
            : 'Not available';
      }
    } catch (e) {
      print('Error parsing action plan: $e');
    }
    return 'Not specified';
  }

  String _getPulseOximeterStatus() {
    try {
      if (widget.patient.doYouHavePulseOximeter != null) {
        print(
          '🔍 Pulse Oximeter raw data: ${widget.patient.doYouHavePulseOximeter}',
        );
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.doYouHavePulseOximeter!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 Pulse Oximeter parsed: $data');
        final hasOximeter = data['ownsPulseOximeter'] == true;
        final lastLevel = data['lastOxygenLevel'];
        return hasOximeter ? 'Yes (Last reading: $lastLevel%)' : 'No';
      }
    } catch (e) {
      print('Error parsing pulse oximeter: $e');
    }
    return 'Not specified';
  }

  String _getHomeOxygenStatus() {
    try {
      if (widget.patient.homeOxygenEnabled != null) {
        print('🔍 Home Oxygen raw data: ${widget.patient.homeOxygenEnabled}');
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.homeOxygenEnabled!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 Home Oxygen parsed: $data');
        final hasOxygen = data['hasHomeOxygen'] == true;
        if (hasOxygen) {
          final liters = data['oxygenLitresPerMinute'];
          final hours = data['oxygenHoursPerDay'];
          return 'Yes (${liters}L/min, ${hours}hrs/day)';
        }
        return 'No';
      }
    } catch (e) {
      print('Error parsing home oxygen: $e');
    }
    return 'Not specified';
  }

  String _getStethoscopeStatus() {
    print(
      '🔍 Stethoscope raw data: ${widget.patient.isDoHaveDigitalStethoscope}',
    );
    return widget.patient.isDoHaveDigitalStethoscope ?? 'Not specified';
  }

  String _getInhalerInfo() {
    try {
      if (widget.patient.inhalerType != null) {
        print('🔍 Inhaler raw data: ${widget.patient.inhalerType}');
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.inhalerType!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 Inhaler parsed: $data');
        final inhalers = data['inhalers'] as List?;
        if (inhalers != null && inhalers.isNotEmpty) {
          final inhaler = inhalers.first;
          return '${inhaler['name']} (${inhaler['dosage']})';
        }
      }
    } catch (e) {
      print('Error parsing inhaler: $e');
    }
    return 'Not specified';
  }

  String _getRescuePackStatus() {
    try {
      if (widget.patient.rescuepackAtHome != null) {
        print('🔍 Rescue Pack raw data: ${widget.patient.rescuepackAtHome}');
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.rescuepackAtHome!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 Rescue Pack parsed: $data');
        return data['hasRescuePack'] == true ? 'Available' : 'Not available';
      }
    } catch (e) {
      print('Error parsing rescue pack: $e');
    }
    return 'Not specified';
  }

  String _getEmergencyContact() {
    try {
      if (widget.patient.emergencyContactName != null) {
        print(
          '🔍 Emergency Contact raw data: ${widget.patient.emergencyContactName}',
        );
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.emergencyContactName!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 Emergency Contact parsed: $data');
        final name = data['emergencyContactName'];
        final phone = data['emergencyContactPhone'];
        return '$name ($phone)';
      }
    } catch (e) {
      print('Error parsing emergency contact: $e');
    }
    return 'Not specified';
  }

  String _getVaccinationStatus() {
    try {
      if (widget.patient.fluVaccinated != null) {
        print('🔍 Vaccination raw data: ${widget.patient.fluVaccinated}');
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.fluVaccinated!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 Vaccination parsed: $data');
        final vaccinations = data['vaccinations'] as List?;
        if (vaccinations != null && vaccinations.isNotEmpty) {
          return vaccinations.join(', ');
        }
      }
    } catch (e) {
      print('Error parsing vaccination: $e');
    }
    return 'Not specified';
  }

  String _getSmokingStatus() {
    try {
      if (widget.patient.smokingStatus != null) {
        print('🔍 Smoking Status raw data: ${widget.patient.smokingStatus}');
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.smokingStatus!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 Smoking Status parsed: $data');
        final status = data['smokingStatus'];
        final cigarettes = data['cigarettesPerDay'];
        final years = data['smokingYears'];
        return '$status ($cigarettes cigs/day, $years years)';
      }
    } catch (e) {
      print('Error parsing smoking status: $e');
    }
    return 'Not specified';
  }

  String _getOtherConditions() {
    try {
      if (widget.patient.otherCondition != null) {
        print('🔍 Other Conditions raw data: ${widget.patient.otherCondition}');
        // Handle the double-quoted JSON string
        String jsonString = widget.patient.otherCondition!;
        // Remove outer quotes if present
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        // Unescape the JSON
        jsonString = jsonString.replaceAll('\\"', '"');
        final data = json.decode(jsonString);
        print('🔍 Other Conditions parsed: $data');
        final conditions = data['otherConditions'] as List?;
        final text = data['otherConditionText'];
        if (conditions != null && conditions.isNotEmpty) {
          return '${conditions.join(', ')}${text != null ? ' - $text' : ''}';
        }
      }
    } catch (e) {
      print('Error parsing other conditions: $e');
    }
    return 'Not specified';
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthScreenMobile()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
