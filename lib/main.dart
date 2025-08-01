import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import ' features/auth/auth_screen_mobile.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with robust error handling
  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isNotEmpty) {
      print('Firebase already initialized, using existing app');
      Firebase.app();
    } else {
      print('Initializing Firebase...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully');
    }
  } catch (e) {
    print('Firebase initialization error: $e');
    if (e.toString().contains('duplicate-app')) {
      print('Firebase already initialized, continuing...');
    } else {
      print('Unexpected Firebase error, rethrowing...');
      rethrow;
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COPD Clinical Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthScreenMobile(),
      debugShowCheckedModeBanner: false,
    );
  }
}
