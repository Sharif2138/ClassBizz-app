import 'package:classbizz_app/models/users_model.dart';
import 'package:classbizz_app/models/session_model.dart';
import 'package:classbizz_app/models/attendee_model.dart';
import 'package:classbizz_app/providers/auth_provider.dart';
import 'package:classbizz_app/providers/session_provider.dart';
import 'package:classbizz_app/screens/lecturer/lecturer_bottom_nav.dart';
import 'package:classbizz_app/screens/student/after_session_screen.dart';
import 'package:classbizz_app/screens/student/student_bottom_nav.dart';
import 'package:classbizz_app/screens/shared/live_leaderboard_screen.dart';
import 'package:classbizz_app/widgets/live_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SessionScreen extends StatelessWidget {
  final String sessionId;
  final String? lecturerId;
  const SessionScreen({super.key, required this.sessionId, this.lecturerId});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.read<SessionProvider>();
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;
    final userUid = currentUser?.uid;

    if (userUid == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    // 1. Stream for User Data (Outermost layer, rarely rebuilds)
    return StreamBuilder<UserModel?>(
      stream: sessionProvider.userStream(userUid),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userdata = userSnapshot.data;
        if (userdata == null) {
          return const Scaffold(
            body: Center(child: Text('User data not found')),
          );
        }

        final bool isLecturer = !userdata.isStudent;

        // 2. Stream for Session Data (Middle layer, rebuilds if session details or status changes)
        return StreamBuilder<SessionModel?>(
          stream: sessionProvider.sessionStream(sessionId),
          builder: (context, sessionSnapshot) {
            if (sessionSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!sessionSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: Text('Session not found')),
              );
            }

            final session = sessionSnapshot.data!;

            // Handle session ending and navigation
            if (session.status == 'ended') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (isLecturer) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LecturerBottomNav(),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AfterSessionScreen(sessionId: session.sessionId, lecturerId: session.lecturerId),
                    ),
                  );
                }
              });
              return const Center(child: CircularProgressIndicator());
            }

            // The main Scaffold starts here.
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 252, 251, 251),
              body: Column(
                children: [
                  // Header is built here, it only rebuilds when SessionModel changes.
                  _buildHeader(session, sessionProvider, context),
                  const SizedBox(height: 10),

                  // 3. Stream for Attendee Data (Innermost layer, rebuilds when students join/leave/points change)
                  // Only this Expanded section should rebuild frequently.
                  Expanded(
                    child: StreamBuilder<List<AttendeeModel>>(
                      stream: sessionProvider.attendeeStream(sessionId),
                      builder: (context, attendeesSnapshot) {
                        if (attendeesSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }

                        final attendees = attendeesSnapshot.data ?? [];

                        return Column(
                          children: [
                            Text(
                              '${attendees.length} Students in the session',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: attendees.isEmpty
                                  ? const Center(
                                      child: Text('No student has joined yet'),
                                    )
                                  : GridView.builder(
                                      padding: const EdgeInsets.all(12),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width >
                                                    600
                                                ? 5
                                                : 3,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 0.8,
                                          ),
                                      itemCount: attendees.length,
                                      itemBuilder: (context, index) {
                                        final attendee = attendees[index];
                                        final initials = _buildInitials(
                                          attendee.name,
                                        );
                                        // StudentCard handles its OWN point animation via its internal StreamBuilder
                                        return StudentCard(
                                          key: ValueKey(attendee.uid),
                                          sessionId: session.sessionId,
                                          attendee: attendee,
                                          initials: initials,
                                          isLecturer: isLecturer,
                                        );
                                      },
                                    ),
                            ),
                            const SizedBox(height: 10),
                            // Action buttons at the bottom of the attendee list
                            if (isLecturer)
                              SizedBox(
                                width: 100,
                                height: 50,
                                child: FloatingActionButton(
                                  onPressed: () =>
                                      sessionProvider.endSession(sessionId),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "End Session",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            if (!isLecturer)
                              SizedBox(
                                width: 120,
                                height: 50,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    sessionProvider.leaveSession(
                                      sessionId: sessionId,
                                      uid: currentUser!.uid,
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const StudentBottomNav(),
                                      ),
                                    );
                                  },
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Leave Session",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ), 
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(SessionModel session, SessionProvider sessionProvider, BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- Top Row: Session Name + Actions ---
              Row(
                children: [
                  Expanded(
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

                  IconButton(
                    icon: const Icon(Icons.bar_chart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LiveLeaderboardScreen(
                            sessionId: session.sessionId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// --- Topic (Optional) ---
              if (session.topic != null)
                Text(
                  session.topic!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: 12),

              /// --- Lecturer Name ---
              StreamBuilder(
                stream: sessionProvider.userStream(session.lecturerId),
                builder: (context, snapshot) {
                  final lecturerName = snapshot.hasData
                      ? snapshot.data!.name
                      : 'Lecturer';

                  return Text(
                    'Lecturer: $lecturerName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Code: ${session.sessionId}',
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(width: 6),

                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: session.sessionId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied session code')),
                      );
                    },
                    child: const Icon(
                      Icons.copy,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),

                  const Spacer(),

                  const LiveIndicator(),
                ],
              ),
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

// ---------------- Student Card ----------------
class StudentCard extends StatefulWidget {
  final String sessionId;
  final AttendeeModel attendee;
  final String initials;
  final bool isLecturer;

  const StudentCard({
    super.key,
    required this.sessionId,
    required this.attendee,
    required this.initials,
    required this.isLecturer,
  });

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard>
    with SingleTickerProviderStateMixin {
  // Removed: late int localPoints;

  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Color?> _colorAnimation;

  // New: Store the last known point value from the stream to compare against
  int _lastPoints = 0;

  @override
  void initState() {
    super.initState();
    _lastPoints = widget.attendee.points; // Initialize with the starting value

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scale =
        Tween<double>(begin: 1.0, end: 1.35).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) _controller.reverse();
        });

    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.green,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _awardAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.read<SessionProvider>();

    // Each card listens to its own attendee stream (Optimal isolation)
    return StreamBuilder<AttendeeModel?>(
      stream: sessionProvider.attendeeStreamByUid(
        widget.sessionId,
        widget.attendee.uid,
      ),
      builder: (context, snapshot) {
        // Use the snapshot data, fallback to initial widget data if null
        final attendee = snapshot.data ?? widget.attendee;

        // Check if points have increased from the last recorded value
        if (attendee.points > _lastPoints) {
          _awardAnimation();
        }
        // Update the last recorded points
        _lastPoints = attendee.points;

        return _buildCard(attendee);
      },
    );
  }

  Widget _buildCard(AttendeeModel attendee) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 229, 242, 141),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 190, 187, 187),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scale,
            child: CircleAvatar(
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
          ),
          const SizedBox(height: 6),
          Text(
            attendee.name,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // --- POINTS DISPLAY WITH ANIMATION ---
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                child: TweenAnimationBuilder<int>(
                  // TweenAnimationBuilder handles the smooth number update automatically
                  // The `end` value comes directly from the current stream snapshot (attendee.points)
                  tween: IntTween(begin: attendee.points, end: attendee.points),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, value, child) {
                    return Text(
                      '${attendee.points} pts', // Use attendee.points directly as the source of truth
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _colorAnimation.value,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // --- LECTURER BUTTONS ---
          if (widget.isLecturer)
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
      onTap: () async {
        final provider = context.read<SessionProvider>();
        await provider.awardPoints(
          sessionId: widget.sessionId,
          uid: widget.attendee.uid,
          points: pts,
        );
      },
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
