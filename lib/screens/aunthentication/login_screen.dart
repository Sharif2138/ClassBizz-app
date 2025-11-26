// ignore_for_file: use_build_context_synchronously

import 'package:classbizz_app/main.dart';
import 'package:classbizz_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isStudent = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final bool isLoading = auth.isLoading;
    final bool isLoadingGoogle = auth.isLoadingGoogle;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 10),

                // Title
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  "Login to continue your learning journey.",
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 40),

                // Email Input
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Password Input
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter your password'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;

                            final authProvider = context.read<AuthProvider>();

                            await authProvider.signIn(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            if (authProvider.errorMessage != null) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage!),
                                  ),
                                );
                                authProvider.clearError();
                              }
                            } else {
                              if (mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AuthWrapper(),
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 20),

                // Google Sign-In Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: isLoadingGoogle ? null : () async { 
                      final authProvider = context.read<AuthProvider>();
                      await authProvider.signInWithGoogle(); 

                      if (authProvider.errorMessage != null) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(authProvider.errorMessage!),
                            ),
                          );
                          authProvider.clearError();
                        }
                      }
                      },
                    icon: isLoadingGoogle
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const FaIcon(
                            FontAwesomeIcons.google,
                            size: 20,
                            color: Colors.red,
                          ),
                    label: const Text(
                      "Continue with Google",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300, width: 1.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Sign Up Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
