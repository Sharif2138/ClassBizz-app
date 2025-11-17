import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isStudent = true;

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
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
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
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: Colors.black,
                  size: 30,
                ),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
