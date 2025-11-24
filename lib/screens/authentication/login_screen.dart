import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isStudent = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            const Text('I am a', style: TextStyle(fontSize: 16)),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _RoleButton(
                    title: 'Student',
                    isActive: isStudent,
                    icon: Icons.school,
                    onTap: () => setState(() => isStudent = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RoleButton(
                    title: 'Facilitator',
                    isActive: !isStudent,
                    icon: Icons.person,
                    onTap: () => setState(() => isStudent = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Email field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return ElevatedButton(
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text;
                            final messenger = ScaffoldMessenger.of(context);

                            if (email.isEmpty || password.isEmpty) {
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter email and password',
                                  ),
                                ),
                              );
                              return;
                            }

                            final navigator = Navigator.of(context);
                            await auth.signIn(email, password);

                            if (!mounted) return;

                            if (auth.errorMessage != null) {
                              messenger.showSnackBar(
                                SnackBar(content: Text(auth.errorMessage!)),
                              );
                            } else {
                              navigator.pushReplacementNamed('/');
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: auth.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () async {
                    final auth = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);

                    await auth.signInWithGoogle(isStudent);

                    if (!context.mounted) return;

                    if (auth.errorMessage != null) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(auth.errorMessage!)),
                      );
                    } else {
                      navigator.pushReplacementNamed('/');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Simple Google "G" logo representation
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily:
                                  'Roboto', // Google uses Roboto usually
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleButton({
    required this.title,
    required this.isActive,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: isActive ? Colors.blueAccent.withAlpha(26) : Colors.white,
          border: Border.all(
            color: isActive ? Colors.blueAccent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.blueAccent : Colors.grey,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.blueAccent : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
