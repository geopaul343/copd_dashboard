import 'package:copd_clinical_dashbord/%20features/auth/auth_screen_mobile.dart';
import 'package:copd_clinical_dashbord/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class MonthlyCheckScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const MonthlyCheckScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<MonthlyCheckScreen> createState() => _MonthlyCheckScreenState();
}

class _MonthlyCheckScreenState extends State<MonthlyCheckScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _monthlyData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMonthlyData();
  }

  Future<void> _loadMonthlyData() async {
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
      final result = await _apiService.getMonthlyData(
        idToken!,
        widget.patientId,
      );

      if (result['success']) {
        setState(() {
          _monthlyData = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['error'] ?? 'Failed to load monthly data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading monthly data: $e';
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
          'Monthly Check',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.purple.shade700,
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
                    CircularProgressIndicator(color: Colors.purple.shade700),
                    SizedBox(height: 16),
                    Text(
                      'Loading monthly data...',
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
                      onPressed: _loadMonthlyData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade700,
                      ),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
              : _buildMonthlyContent(),
    );
  }

  Widget _buildMonthlyContent() {
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
                colors: [Colors.purple.shade700, Colors.purple.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_month, size: 48, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Monthly Health Report',
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
                  'This Month\'s Summary',
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Monthly Statistics
          _buildSection('Monthly Statistics', Icons.analytics, [
            _buildStatCard(
              'Average Oxygen Level',
              '93%',
              '+3% from last month',
              Icons.trending_up,
              Colors.green,
            ),
            _buildStatCard(
              'Hospital Visits',
              '1',
              '-2 from last month',
              Icons.local_hospital,
              Colors.red,
            ),
            _buildStatCard(
              'Medication Adherence',
              '96%',
              '+2% from last month',
              Icons.medication,
              Colors.blue,
            ),
            _buildStatCard(
              'Exercise Sessions',
              '22/30',
              '73% completion rate',
              Icons.fitness_center,
              Colors.orange,
            ),
          ]),
          SizedBox(height: 24),

          // Monthly Progress Chart
          _buildSection('Monthly Progress', Icons.show_chart, [
            Container(
              height: 250,
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
                    'Weekly Oxygen Level Trends',
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
                        _buildWeekBar('Week 1', 91, Colors.purple.shade300),
                        _buildWeekBar('Week 2', 93, Colors.purple.shade400),
                        _buildWeekBar('Week 3', 95, Colors.purple.shade500),
                        _buildWeekBar('Week 4', 94, Colors.purple.shade600),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
          SizedBox(height: 24),

          // Monthly Achievements
          _buildSection('Monthly Achievements', Icons.emoji_events, [
            _buildAchievementItem(
              'Perfect Medication Week',
              'Completed all medications for 7 consecutive days',
              Icons.medication,
              Colors.green,
            ),
            _buildAchievementItem(
              'Exercise Champion',
              'Completed 5 exercise sessions in one week',
              Icons.fitness_center,
              Colors.blue,
            ),
            _buildAchievementItem(
              'Oxygen Master',
              'Maintained oxygen levels above 90% for 10 days',
              Icons.favorite,
              Colors.red,
            ),
            _buildAchievementItem(
              'Symptom Free',
              'No major symptoms reported for 5 days',
              Icons.sentiment_satisfied,
              Colors.orange,
            ),
          ]),
          SizedBox(height: 24),

          // Monthly Goals Progress
          _buildSection('Monthly Goals Progress', Icons.flag, [
            _buildGoalProgress('Reduce hospital visits', 100, '1/1 target'),
            _buildGoalProgress('Improve oxygen levels', 85, '93% target'),
            _buildGoalProgress(
              'Increase exercise frequency',
              73,
              '22/30 sessions',
            ),
            _buildGoalProgress(
              'Maintain medication schedule',
              96,
              '96% adherence',
            ),
          ]),
          SizedBox(height: 24),

          // Monthly Summary
          _buildSection('Monthly Summary', Icons.note, [
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
                    'Monthly Assessment:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Excellent progress this month! Patient has shown significant improvement in oxygen levels and overall health. Hospital visits reduced by 50%. Exercise adherence improved. Medication compliance remains excellent. Patient reports feeling more energetic and experiencing fewer symptoms. Continue with current treatment plan and consider increasing exercise frequency.',
                    style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                  ),
                ],
              ),
            ),
          ]),
          SizedBox(height: 24),

          // Next Month Goals
          _buildSection('Next Month Goals', Icons.forward, [
            _buildNextGoal('Reduce hospital visits to 0', 'High Priority'),
            _buildNextGoal(
              'Increase exercise to 25 sessions',
              'Medium Priority',
            ),
            _buildNextGoal('Maintain oxygen levels above 94%', 'High Priority'),
            _buildNextGoal(
              'Attend all scheduled appointments',
              'Medium Priority',
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
            Icon(icon, color: Colors.purple.shade700, size: 24),
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

  Widget _buildStatCard(
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
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  change,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekBar(String week, int value, Color color) {
    final height = (value / 100) * 150; // Scale to max 150 height
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        SizedBox(height: 8),
        Text(week, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        Text(
          '$value%',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(
    String title,
    String description,
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
        border: Border.all(color: color.withOpacity(0.3)),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(Icons.emoji_events, color: Colors.amber, size: 24),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(String goal, int progress, String status) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                goal,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                status,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade700),
          ),
          SizedBox(height: 4),
          Text(
            '$progress% Complete',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildNextGoal(String goal, String priority) {
    Color priorityColor =
        priority == 'High Priority' ? Colors.red : Colors.orange;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: priorityColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.flag, color: priorityColor, size: 24),
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
              color: priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              priority,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: priorityColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
