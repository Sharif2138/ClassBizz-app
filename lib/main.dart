import 'package:flutter/material.dart';
import 'package:classbizz_app/screens/aunthentication/Home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ClassBizz());
}

class ClassBizz extends StatelessWidget {
  const ClassBizz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassBizz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 👇👇 Add this block below
      routes: {
        '/student/dashboard': (context) => const StudentDashboardScreen(),
        '/student/join': (context) => const JoinSessionScreen(),
        '/student/review': (context) => const ReviewScreen(),
        '/student/profile': (context) => const StudentProfileScreen(),
      },
      home: const StudentDashboardScreen(),

    );
  }
}
