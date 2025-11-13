import 'package:classbizz_app/screens/shared/session_screen.dart';
import 'package:classbizz_app/screens/student/student_dashboard_screen.dart';
import 'package:classbizz_app/screens/lecturer/lecturer_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'screens/aunthentication/home_screen.dart';
import 'screens/aunthentication/signup_screen.dart';
import 'screens/aunthentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'services/firestore_service.dart'; // removed: file does not exist

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ClassBizzApp());
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
        '/': (context) => AuthWrapper(),
        'home': (context) => const HomeScreen(),
        '/student/dashboard': (context) => const StudentDashboardScreen(),
        '/lecturer/dashboard': (context) => const LecturerDashboardScreen(),
        '/login':(context) => const LoginScreen(),
        '/signup':(context) => const SignUpScreen(),
       },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final firebaseUser = snapshot.data;

        if (firebaseUser == null) return const HomeScreen();

        if (!firebaseUser.emailVerified) {
          // Show a UI prompting the user to verify their email with actions
          return Scaffold(
            appBar: AppBar(title: const Text('Verify your email')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please verify your email.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await firebaseUser.sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Verification email sent')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to send email: $e')),
                        );
                      }
                    },
                    child: const Text('Resend verification email'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          );
        }

        // User is signed in and email is verified
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .get(),
          builder: (context, documentSnapshot) {
            if (documentSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!documentSnapshot.hasData || !documentSnapshot.data!.exists) {
              return const Center(child: Text('User data not found.'));
            }

            final user = documentSnapshot.data!.data() as Map<String, dynamic>;
            final bool isStudent = user['isStudent'];
            if (isStudent == true) {
              return const StudentDashboardScreen();
            } else {
              return const LecturerDashboardScreen();
            }
          },
        );
      },
    );
  }
}