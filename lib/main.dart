import 'package:flutter/material.dart';
import 'package:classbizz_app/screens/aunthentication/Home_screen.dart';
import 'package:classbizz_app/screens/student/student_dashboard_screen.dart';
import 'package:classbizz_app/screens/student/join_session_screen.dart';

void main() {
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
      },
      home: const StudentDashboardScreen(),

    );
  }
}
