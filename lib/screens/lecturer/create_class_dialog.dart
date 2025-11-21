import 'package:classbizz_app/screens/shared/session_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_provider.dart';
import '../../models/session_model.dart';

class CreateClassDialog extends StatefulWidget {
  const CreateClassDialog({super.key});

  @override
  State<CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends State<CreateClassDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController classNameController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final sessionProvider = context.watch<SessionProvider>();
    final isLoading = sessionProvider.isLoading;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "Create Class",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: classNameController,
                decoration: const InputDecoration(
                  labelText: "Class Name *",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Class name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: topicController,
                decoration: const InputDecoration(
                  labelText: "Topic (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Duration (optional)",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: hoursController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Hours",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: minutesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Minutes",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 38, 128, 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    final className = classNameController.text.trim();
                    final topic = topicController.text.trim().isEmpty
                        ? null
                        : topicController.text.trim();
                    final hours =
                        int.tryParse(hoursController.text.trim()) ?? 0;
                    final minutes =
                        int.tryParse(minutesController.text.trim()) ?? 0;
                    final totalDurationMinutes = (hours * 60) + minutes;

                    try {
                      SessionModel? newSession = await sessionProvider
                          .createSession(
                            lecturerId: user!.uid,
                            name: className,
                            topic: topic,
                            durationMinutes: totalDurationMinutes > 0
                                ? totalDurationMinutes
                                : null,
                          );

                          if(newSession == null) return;

                      if (!mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SessionScreen(sessionId: newSession.sessionId),
                        ),
                      );
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error creating session: $e")),
                        );
                      }
                    }
                  }
                },
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Create", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
