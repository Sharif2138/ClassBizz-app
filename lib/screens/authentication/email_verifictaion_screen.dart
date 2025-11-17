import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        centerTitle: true,
        automaticallyImplyLeading: false, // removes the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mark_email_read,
                size: 100,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 24),
              const Text(
                'Verification Email Sent!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Check your inbox (or spam folder) and verify your email.\n'
                'After verification, you can login to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final user = auth.user;
                  if (user == null) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('No authenticated user')),
                    );
                    return;
                  }

                  try {
                    await user.sendEmailVerification();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Verification email resent!'),
                      ),
                    );
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text('Failed to send email: $e')),
                    );
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Resend Verification Email'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  children: [
                    const Text(
                      'Finished Verifying?',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
