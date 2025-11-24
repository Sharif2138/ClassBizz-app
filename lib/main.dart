import 'package:flutter/material.dart';

import 'package:classbizz_app/screens/student/student_dashboard_screen.dart';
import 'package:classbizz_app/screens/lecturer/lecturer_dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/session_provider.dart';
import 'screens/authentication/home_screen.dart';
import 'screens/authentication/signup_screen.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/authentication/email_verifictaion_screen.dart';

import 'screens/student/student_bottom_nav.dart';
import 'screens/shared/leaderboard_screen.dart';
import 'screens/lecturer/lecturer_bottom_nav.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<SessionProvider>(
          create: (_) => SessionProvider(),
        ),
      ],
      child: const ClassBizzApp(),
    ),
  );
}

class ClassBizzApp extends StatelessWidget {
  const ClassBizzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassBizz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        // '/home': (context) => const HomeScreen(),
        '/student/dashboard': (context) => const StudentDashboardScreen(),
        '/lecturer/dashboard': (context) => const LecturerDashboardScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/email-verification': (context) => EmailVerificationScreen(),
        '/shared/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (auth.user == null) {
      return const WelcomeScreen();
    } else {
      if (!auth.user!.emailVerified) {
        return EmailVerificationScreen();
      } else {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(auth.user!.uid)
              .get(),
          builder: (context, documentSnapshot) {
            if (documentSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!documentSnapshot.hasData || !documentSnapshot.data!.exists) {
              return const WelcomeScreen();
            }

            final user = documentSnapshot.data!.data() as Map<String, dynamic>;
            final bool isStudent = user['isStudent'];
            if (isStudent == true) {
              return const StudentBottomNav();
            } else {
              return const LecturerBottomNav();
            }
          },
        );
      }
    }
  }
}
