import 'package:classbizz_app/screens/aunthentication/home_screen.dart';
import 'package:classbizz_app/screens/shared/session_screen.dart';
import 'package:classbizz_app/screens/student/student_dashboard_screen.dart';
import 'package:classbizz_app/screens/lecturer/lecturer_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/aunthentication/signup_screen.dart';
import 'screens/aunthentication/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/aunthentication/email_verifictaion_screen.dart';
import 'providers/session_provider.dart';
import 'screens/student/student_bottom_nav.dart';
import 'screens/student/join_session_screen.dart';
import 'screens/shared/leaderboard_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<SessionProvider>(create: (_) => SessionProvider()),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        // '/home': (context) => const HomeScreen(),
        '/student/dashboard': (context) => const StudentDashboardScreen(),
        '/lecturer/dashboard': (context) => const LecturerDashboardScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/email-verification': (context) => const EmailVerificationScreen(),
        '/session': (context) => const SessionScreen(),
        '/student/join': (context) => const JoinSessionScreen(),
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
        return const EmailVerificationScreen();
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
              return const LecturerDashboardScreen();
            }
          },
        );
      }
    }
  }
}
