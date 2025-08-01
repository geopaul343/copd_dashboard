import 'package:copd_clinical_dashbord/%20features/auth/auth_screen_mobile.dart';
import 'package:copd_clinical_dashbord/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class WeeklyCheckScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const WeeklyCheckScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<WeeklyCheckScreen> createState() => _WeeklyCheckScreenState();
}

class _WeeklyCheckScreenState extends State<WeeklyCheckScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _weeklyData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeeklyData();
  }

  Future<void> _loadWeeklyData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      final idToken = await user.getIdToken();
      final result = await _apiService.getUserDetails(idToken!, widget.patientId,user.uid);

      if (result['success']) {
        setState(() {
          _weeklyData = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['error'] ?? 'Failed to load weekly data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading weekly data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthScreenMobile()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Weekly Check',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.orange.shade700),
                    SizedBox(height: 16),
                    Text(
                      'Loading weekly data...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadWeeklyData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                      ),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
              : _buildWeeklyContent(),
    );
  }

  Widget _buildWeeklyContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade700, Colors.orange.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.view_week, size: 48, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Weekly Health Summary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.patientName,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 8),
                Text(
                  'This Week\'s Progress',
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Weekly Overview
          _buildSection('Weekly Overview', Icons.analytics, [
            _buildOverviewCard(
              'Average Oxygen Level',
              '94%',
              '+2%',
              Icons.trending_up,
              Colors.green,
            ),
            _buildOverviewCard(
              'Exercise Sessions',
              '5/7',
              '71%',
              Icons.fitness_center,
              Colors.blue,
            ),
            _buildOverviewCard(
              'Medication Adherence',
              '95%',
              '+5%',
              Icons.medication,
              Colors.purple,
            ),
            _buildOverviewCard(
              'Symptom-Free Days',
              '4/7',
              '57%',
              Icons.sentiment_satisfied,
              Colors.orange,
            ),
          ]),
          SizedBox(height: 24),

          // Weekly Chart
          _buildSection('Oxygen Levels Trend', Icons.show_chart, [
            Container(
              height: 200,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Oxygen Levels',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar('Mon', 92, Colors.orange.shade300),
                        _buildBar('Tue', 94, Colors.orange.shade400),
                        _buildBar('Wed', 96, Colors.orange.shade500),
                        _buildBar('Thu', 93, Colors.orange.shade400),
                        _buildBar('Fri', 95, Colors.orange.shade500),
                        _buildBar('Sat', 97, Colors.orange.shade600),
                        _buildBar('Sun', 94, Colors.orange.shade400),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
          SizedBox(height: 24),

          // Weekly Activities
          _buildSection('Weekly Activities', Icons.calendar_view_week, [
            _buildWeeklyActivity(
              'Monday',
              'Morning walk, Medication taken',
              true,
            ),
            _buildWeeklyActivity(
              'Tuesday',
              'Oxygen therapy, Exercise session',
              true,
            ),
            _buildWeeklyActivity(
              'Wednesday',
              'Doctor appointment, Medication taken',
              true,
            ),
            _buildWeeklyActivity(
              'Thursday',
              'Rest day, Light stretching',
              false,
            ),
            _buildWeeklyActivity(
              'Friday',
              'Oxygen therapy, Evening walk',
              true,
            ),
            _buildWeeklyActivity(
              'Saturday',
              'Family visit, Medication taken',
              true,
            ),
            _buildWeeklyActivity(
              'Sunday',
              'Rest day, Planning for next week',
              false,
            ),
          ]),
          SizedBox(height: 24),

          // Weekly Goals
          _buildSection('Weekly Goals', Icons.flag, [
            _buildGoalItem('Complete 5 exercise sessions', true, '5/5'),
            _buildGoalItem(
              'Maintain oxygen levels above 90%',
              true,
              '7/7 days',
            ),
            _buildGoalItem('Take all medications on time', true, '95%'),
            _buildGoalItem('Walk for 30 minutes daily', false, '4/7 days'),
            _buildGoalItem('Attend support group meeting', true, '1/1'),
          ]),
          SizedBox(height: 24),

          // Weekly Notes
          _buildSection('Weekly Summary', Icons.note, [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Assessment:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Good progress this week. Oxygen levels improved significantly. Exercise adherence was excellent. Medication compliance remains high. Patient reported feeling more energetic and less shortness of breath. Continue with current treatment plan.',
                    style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                  ),
                ],
              ),
            ),
          ]),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.orange.shade700, size: 24),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildOverviewCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        change,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, int value, Color color) {
    final height = (value / 100) * 120; // Scale to max 120 height
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        Text(
          '$value%',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildWeeklyActivity(String day, String activity, bool completed) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed ? Colors.green.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: completed ? Colors.green : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  activity,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.grey.shade400,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String goal, bool achieved, String progress) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achieved ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            achieved ? Icons.check_circle : Icons.pending,
            color: achieved ? Colors.green : Colors.orange,
            size: 24,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              goal,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  achieved
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              progress,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: achieved ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
