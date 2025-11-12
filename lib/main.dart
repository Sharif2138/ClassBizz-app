import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/aunthentication/home_screen.dart';
import 'screens/aunthentication/signup_screen.dart';
import 'screens/aunthentication/login_screen.dart';

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
        '/': (context) => const WelcomeScreen(),
        '/login':(context) => const LoginScreen(),
        '/signup':(context) => const SignUpScreen(),
       },
    );
  }
}
