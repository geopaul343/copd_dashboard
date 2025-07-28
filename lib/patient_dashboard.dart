import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/search_response.dart';
import 'auth_screen_mobile.dart';
import 'dart:convert';

class PatientDashboard extends StatefulWidget {
  final PatientUser patient;

  const PatientDashboard({Key? key, required this.patient}) : super(key: key);

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
    return _buildSection('Patient Demographics', Icons.person_outline, [
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
    return _buildSection('COPD Assessment', Icons.medical_services, [
      _buildInfoRow('COPD Diagnosed', _getCOPDDiagnosis()),
      _buildInfoRow('COPD Stage', _getCOPDStage()),
      if (widget.patient.copdActionPlan != null)
        _buildInfoRow('Action Plan', _getActionPlanStatus()),
    ]);
  }

  Widget _buildMedicalEquipmentSection() {
    return _buildSection(
      'Medical Equipment & Monitoring',
      Icons.monitor_heart,
      [
        _buildInfoRow('Pulse Oximeter', _getPulseOximeterStatus()),
        _buildInfoRow('Home Oxygen', _getHomeOxygenStatus()),
        _buildInfoRow('Digital Stethoscope', _getStethoscopeStatus()),
      ],
    );
  }

  Widget _buildMedicationsSection() {
    return _buildSection('Medications & Treatment', Icons.medication, [
      _buildInfoRow('Inhaler Type', _getInhalerInfo()),
      _buildInfoRow('Rescue Pack', _getRescuePackStatus()),
      if (widget.patient.anyRecommends != null)
        _buildInfoRow('Recommendations', widget.patient.anyRecommends!),
    ]);
  }

  Widget _buildEmergencySection() {
    return _buildSection('Emergency Information', Icons.emergency, [
      _buildInfoRow('Emergency Contact', _getEmergencyContact()),
    ]);
  }

  Widget _buildVaccinationSection() {
    return _buildSection('Vaccination & Prevention', Icons.vaccines, [
      _buildInfoRow('Flu Vaccination', _getVaccinationStatus()),
    ]);
  }

  Widget _buildLifestyleSection() {
    return _buildSection('Lifestyle & Risk Factors', Icons.smoking_rooms, [
      _buildInfoRow('Smoking Status', _getSmokingStatus()),
      _buildInfoRow('Other Conditions', _getOtherConditions()),
    ]);
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
        // Remove extra quotes if present
        String jsonString = widget.patient.copdDiagnosed!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
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
        // Remove extra quotes if present
        String jsonString = widget.patient.copdDiagnosed!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
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
        // Remove extra quotes if present
        String jsonString = widget.patient.copdActionPlan!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
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
        // Remove extra quotes if present
        String jsonString = widget.patient.doYouHavePulseOximeter!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
        final hasOximeter = data['ownsPulseOximeter'] == true;
        final lastLevel = data['lastOxygenLevel'];
        return hasOximeter ? 'Yes (Last reading: ${lastLevel}%)' : 'No';
      }
    } catch (e) {
      print('Error parsing pulse oximeter: $e');
    }
    return 'Not specified';
  }

  String _getHomeOxygenStatus() {
    try {
      if (widget.patient.homeOxygenEnabled != null) {
        // Remove extra quotes if present
        String jsonString = widget.patient.homeOxygenEnabled!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
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
    return widget.patient.isDoHaveDigitalStethoscope ?? 'Not specified';
  }

  String _getInhalerInfo() {
    try {
      if (widget.patient.inhalerType != null) {
        // Remove extra quotes if present
        String jsonString = widget.patient.inhalerType!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
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
        // Remove extra quotes if present
        String jsonString = widget.patient.rescuepackAtHome!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
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
        // Remove extra quotes if present
        String jsonString = widget.patient.emergencyContactName!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
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
        // Remove extra quotes if present
        String jsonString = widget.patient.fluVaccinated!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
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
        // Remove extra quotes if present
        String jsonString = widget.patient.smokingStatus!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
        final status = data['smokingStatus'];
        final cigarettes = data['cigarettesPerDay'];
        final years = data['smokingYears'];
        return '$status (${cigarettes} cigs/day, ${years} years)';
      }
    } catch (e) {
      print('Error parsing smoking status: $e');
    }
    return 'Not specified';
  }

  String _getOtherConditions() {
    try {
      if (widget.patient.otherCondition != null) {
        // Remove extra quotes if present
        String jsonString = widget.patient.otherCondition!;
        if (jsonString.startsWith('"') && jsonString.endsWith('"')) {
          jsonString = jsonString.substring(1, jsonString.length - 1);
        }
        final data = json.decode(jsonString);
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
