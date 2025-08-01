import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../patient_search/patient_search_screen.dart';
import '../../core/services/api_service.dart';

class AuthScreenMobile extends StatefulWidget {
  const AuthScreenMobile({super.key});

  @override
  State<AuthScreenMobile> createState() => _AuthScreenMobileState();
}

class _AuthScreenMobileState extends State<AuthScreenMobile>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoading = false;

  String? _error;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    print('=== GOOGLE SIGN-IN DEBUG START ===');
    print('🔍 Starting Google Sign-In process...');

    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        print('❌ Firebase not initialized');
        setState(() {
          _error = 'Firebase not initialized. Please restart the app.';
          _isLoading = false;
        });
        return;
      }

      print('🔍 Firebase project: ${Firebase.app().options.projectId}');
      print('🔍 Google Sign-In client ID: ${_googleSignIn.clientId}');
      print('🔍 Triggering Google Sign-In...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('❌ User cancelled Google Sign-In');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      print('✅ Google Sign-In successful');
      print('✅ User email: ${googleUser.email}');
      print('✅ User display name: ${googleUser.displayName}');

      print('🔍 Getting Google Auth credentials...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('✅ Google Auth successful');
      print(
        '✅ Access token: ${googleAuth.accessToken != null ? "Present" : "Missing"}',
      );
      print(
        '✅ ID token: ${googleAuth.idToken != null ? "Present" : "Missing"}',
      );

      print('🔍 Creating Firebase credential...');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔍 Signing in to Firebase...');
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      print('✅ Firebase sign-in successful');
      print('✅ Firebase user ID: ${userCredential.user?.uid}');
      print('✅ Firebase user email: ${userCredential.user?.email}');

      // Call backend API
      print('🔍 Calling backend API...');
      try {
        final apiService = ApiService();
        final idToken = await userCredential.user!.getIdToken();
        final response = await apiService.loginUser(
          userCredential.user!,
          idToken,
        );
        print('✅ Backend API call successful: $response');
      } catch (apiError) {
        print('⚠️ Backend API call failed: $apiError');
        // Continue anyway - user is authenticated with Firebase
      }

      if (mounted) {
        print('✅ Navigating to patient search...');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PatientSearchScreen()),
        );
      }

      print('=== GOOGLE SIGN-IN DEBUG END ===');
    } catch (e) {
      print('=== GOOGLE SIGN-IN ERROR DEBUG ===');
      print('❌ Sign-in error type: ${e.runtimeType}');
      print('❌ Sign-in error details: $e');
      print('❌ Error stack trace: ${StackTrace.current}');

      setState(() {
        _error = 'Sign-in failed: ${e.toString()}';
        _isLoading = false;
      });

      print('=== GOOGLE SIGN-IN ERROR DEBUG END ===');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Title Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // App Logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.medical_services,
                          size: 60,
                          color: Colors.blue.shade600,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // App Title
                      Text(
                        'COPD Clinical',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                          letterSpacing: 1.2,
                        ),
                      ),

                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade600,
                          letterSpacing: 1.0,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle
                      Text(
                        'Professional Patient Management System',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Authentication Section
                SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Nurse Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            size: 40,
                            color: Colors.blue.shade600,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Title
                        Text(
                          'Clinical Nurse Access',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Description
                        Text(
                          'Sign in with your Google account to access patient records and manage COPD care',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // Google Sign-In Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _signInWithGoogle,
                            icon:
                                _isLoading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Image.asset(
                                      'assets/google_logo.png',
                                      height: 24,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Icon(
                                          Icons.login,
                                          color: Colors.white,
                                          size: 24,
                                        );
                                      },
                                    ),
                            label: Text(
                              _isLoading
                                  ? 'Signing In...'
                                  : 'Sign in with Google',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),

                        // Error Message
                        if (_error != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Footer
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Secure • HIPAA Compliant • Professional',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
