import 'package:flutter/material.dart';
import 'package:classbizz_app/screens/lecturer/lecturer_dashboard_screen.dart';

void main() {
  runApp(const ClassBizz());
}

class ClassBizz extends StatelessWidget {
  const ClassBizz({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassBizz App',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LecturerDashboardScreen(),
    );
  }
}

