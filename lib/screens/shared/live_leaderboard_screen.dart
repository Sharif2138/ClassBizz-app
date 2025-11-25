import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/live_icon.dart';
import '../../widgets/leaderboard_tile.dart';

class LiveLeaderboardScreen extends StatelessWidget {
  final String sessionId;
  const LiveLeaderboardScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Leaderboard",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),

            LiveIndicator(),
          ],
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sessions')
            .doc(sessionId)
            .collection('attendees')
            .orderBy('points', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final attendees = snapshot.data!.docs;

          if (attendees.isEmpty) {
            return const Center(
              child: Text("No attendees yet", style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: attendees.length,
            itemBuilder: (context, index) {
              final attendee = attendees[index];
              final name = attendee['name'] ?? "Unknown";
              final points = attendee['points'] ?? 0;

              return LeaderboardTile(
                rank: index + 1,
                name: name,
                points: points,
              );
            },
          );
        },
      ),
    );
  }
}

