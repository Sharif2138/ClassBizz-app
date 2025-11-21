import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:classbizz_app/providers/session_provider.dart';
import 'package:classbizz_app/models/session_model.dart';
import 'package:classbizz_app/models/attendee_model.dart';

class SessionScreen extends StatelessWidget {
  final String sessionId;
  const SessionScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    // final currentUser = context.watch<AuthProvider>().currentUser;

    // Listen to the session document (real-time)
    return StreamBuilder<SessionModel?>(
      stream: sessionProvider.sessionStream(sessionId),
      builder: (context, sessionSnapshot) {
        if (sessionSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!sessionSnapshot.hasData) {
          return const Scaffold(body: Center(child: Text('Session not found')));
        }

        final session = sessionSnapshot.data!;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              _buildHeader(session, context),
              const SizedBox(height: 10),
              StreamBuilder<List<AttendeeModel>>(
                stream: sessionProvider.attendeeStream(sessionId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 24,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  }
                  final count = snapshot.data?.length ?? 0;
                  return Text(
                    '$count Students in the session',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              Expanded(
                child: StreamBuilder<List<AttendeeModel>>(
                  stream: sessionProvider.attendeeStream(sessionId),
                  builder: (context, attendeesSnapshot) {
                    if (attendeesSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final attendees = attendeesSnapshot.data ?? [];

                    if (attendees.isEmpty) {
                      return const Center(child: Text('No students have joined yet'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: attendees.length,
                      itemBuilder: (context, index) {
                        final a = attendees[index];
                        final initials = _buildInitials(a.name);
                        return StudentCard(
                          sessionId: session.sessionId,
                          attendee: a,
                          initials: initials,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Header: receives a SessionModel so it's pure and testable
  Widget _buildHeader(SessionModel session, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: const [
                  Spacer(),
                  Icon(Icons.bar_chart, color: Colors.white),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      session.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (session.topic != null)
                    Flexible(
                      child: Text(
                        session.topic!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Code: ${session.sessionId}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.white70,
                      size: 18,
                    ),
                    onPressed: () {
                      // Copy code to clipboard
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied session code')),
                      );
                      Clipboard.setData(ClipboardData(text: session.sessionId));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  static String _buildInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

// ---------------- Student Card (separate widget) ----------------
class StudentCard extends StatefulWidget {
  final String sessionId;
  final AttendeeModel attendee;
  final String initials;

  const StudentCard({
    super.key,
    required this.sessionId,
    required this.attendee,
    required this.initials,
  });

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard>
    with SingleTickerProviderStateMixin {
  late int currentPoints;
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    currentPoints = widget.attendee.points;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale =
        Tween<double>(begin: 1.0, end: 1.35).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        )..addStatusListener((s) {
          if (s == AnimationStatus.completed) _controller.reverse();
        });
  }

  Future<void> _award(int pts) async {
    // optimistic local update + animation
    setState(() => currentPoints += pts);
    _controller.forward();

    // call provider to update Firestore (this will cause the stream to emit updated data)
    try {
      final provider = context.read<SessionProvider>();
      await provider.awardPoints(
        sessionId: widget.sessionId,
        uid: widget.attendee.uid,
        points: pts,
      );
      // provider's stream will push the updated value to everyone; local optimistic update already done
    } catch (e) {
      // on error, roll back local change and show error
      setState(() => currentPoints -= pts);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to award points: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF4A90E2),
            radius: 18,
            child: Text(
              widget.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.attendee.name,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          ScaleTransition(
            scale: _scale,
            child: Text(
              '$currentPoints pts',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPointButton('+5', Colors.green, 5),
              _buildPointButton('+3', Colors.blue, 3),
              _buildPointButton('+1', Colors.orange, 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointButton(String label, Color color, int pts) {
    return GestureDetector(
      onTap: () => _award(pts),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
