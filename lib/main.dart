import 'package:flutter/material.dart';
import 'screens/authentication/home_screen.dart';
import 'screens/authentication/login_screen.dart';

void main() {
  runApp(const ClassBizzApp());
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
      home: const WelcomeScreen(),
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
