import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_provider.dart'; 
import '../../models/session_model.dart';

// ---------- MAIN SCREEN WIDGET ----------------------
class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get the current user's UID (essential for all queries)
    final user = context.watch<AuthProvider>().currentUser;
    final uid = user?.uid;

    if (uid == null) {
      // Handle the case where the user object hasn't loaded or is null
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ----- HEADER (User name and Logout) -----
              _ProfileHeader(user: user, uid: uid),

              const SizedBox(height: 20),

              // ----- STATS ROW (Now live data) -----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _StatsRow(uid: uid), // UID for all stats queries
              ),

              const SizedBox(height: 20),

              // ----- SESSION HISTORY (Now live data) -----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Session History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SessionHistoryList(
                      uid: uid,
                    ), // Passes UID to fetch history
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

// ----------------------------------------------------
// ---------- WIDGET 1: LIVE STATS ROW ----------------
// ----------------------------------------------------
class _StatsRow extends StatelessWidget {
  final String uid;
  const _StatsRow({Key? key, required this.uid}) : super(key: key);

  // Helper widget to build stat tiles using StreamBuilder
  Widget _buildStatTile(
    String label,
    Stream<dynamic> stream, {
    String suffix = '',
  }) {
    return StreamBuilder<dynamic>(
      stream: stream,
      initialData: 0,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final value = snapshot.data ?? 0;
        final displayValue = value is double
            ? value.toStringAsFixed(0)
            : value.toString();

        return Expanded(
          child: Column(
            children: [
              Text(
                "$displayValue$suffix",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider containing the data methods
    final sessionProvider = context.read<SessionProvider>();

    return Row(
      children: [
        // 1. Total Sessions Attended
        _buildStatTile(
          "Sessions",
          sessionProvider.getTotalAttendedSessions(uid),
        ),

        // 2. Total Points
        _buildStatTile("Points", sessionProvider.getTotalPoints(uid)),

        // 3. Rank
        _buildStatTile(
          "Rank",
          sessionProvider.getStudentRanking(uid),
          suffix: 'th',
        ),
      ],
    );
  }
}

// ---------- WIDGET 2: LIVE SESSION HISTORY LIST -----
class _SessionHistoryList extends StatelessWidget {
  final String uid;
  const _SessionHistoryList({required this.uid});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.read<SessionProvider>();

    return StreamBuilder<List<SessionModel?>>(
      // Using FutureBuilder because getSessionsByAttendeeId returns a Future
      stream: sessionProvider.getSessionsByAttendeeId(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading sessions: ${snapshot.error}'),
          );
        }

        // Filter out nulls and convert to a list of non-null SessionModel
        final sessions =
            snapshot.data?.whereType<SessionModel>().toList() ?? [];

        if (sessions.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No session history yet."),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];

            // Format date assuming createdAt is a Timestamp or similar
            String formattedDate = 'N/A';
            if (session.createdAt is Timestamp) {
              formattedDate = (session.createdAt as Timestamp)
                  .toDate()
                  .toString()
                  .split(' ')[0];
            }

            // Note: The original code forced status to 'ended' in the FirestoreService.
            // We use the actual status here.
            return _SessionHistoryTile(
              sessionId: session.sessionId,
              uid: uid,
              title: session.name,
              date: formattedDate,
              status: session.status,
            );
          },
        );
      },
    );
  }
}

// ----------------------------------------------------
// ---------- WIDGET 3: LIVE SESSION HISTORY TILE -----
// ----------------------------------------------------
class _SessionHistoryTile extends StatelessWidget {
  final String sessionId;
  final String uid;
  final String title;
  final String date;
  final String status;

  const _SessionHistoryTile({
    Key? key,
    required this.sessionId,
    required this.uid,
    required this.title,
    required this.date,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine icon and color based on status (your original logic)
    Icon leadingIcon;
    Color statusColor;

    if (status == "ended") {
      leadingIcon = const Icon(Icons.check_circle, color: Colors.green);
      statusColor = Colors.green;
    } else if (status == "missed") {
      leadingIcon = const Icon(Icons.cancel, color: Colors.red);
      statusColor = Colors.red;
    } else {
      leadingIcon = const Icon(Icons.help_outline, color: Colors.grey);
      statusColor = Colors.grey;
    }

    // Fetch points earned in this specific session
    final sessionProvider = context.read<SessionProvider>();

    return StreamBuilder<int>(
      // Fetches points for *this specific session*
      stream: sessionProvider.getTotalPointsInSession(sessionId, uid),
      initialData: 0,
      builder: (context, snapshot) {
        final points = snapshot.data ?? 0;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: leadingIcon,
            title: Text(title),
            subtitle: Text(date),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // Show points only if status is completed/ended
                  (status == "ended" ? "+$points" : ""),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------
// ---------- WIDGET 4: PROFILE HEADER ----------------
// ----------------------------------------------------
class _ProfileHeader extends StatelessWidget {
  final user; // Assuming user is firebase_auth.User or similar
  final String uid;
  const _ProfileHeader({this.user, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                const Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 55, color: Colors.grey),
                    ),
                    const SizedBox(height: 15),

                    // --- Rank Icon/Position (Using a separate Stream for header rank) ---
                    const Icon(
                      Icons.emoji_events,
                      color: Color.fromARGB(255, 208, 214, 9),
                      size: 20,
                    ),
                    const SizedBox(height: 5),
                    StreamBuilder<int>(
                      stream: context.read<SessionProvider>().getStudentRanking(
                        uid,
                      ),
                      initialData: 0,
                      builder: (context, snapshot) {
                        final rank = snapshot.data ?? 0;
                        final rankText = rank == 0
                            ? '--'
                            : rank == 1
                            ? '1st'
                            : rank == 2
                            ? '2nd'
                            : rank == 3
                            ? '3rd'
                            : '${rank}th';

                        return Text(
                          rankText,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 3, 8, 13),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'No Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Student",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      user?.email ?? 'No Email',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 110,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          final auth = context.read<AuthProvider>();
                          auth.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            205,
                            36,
                            2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
