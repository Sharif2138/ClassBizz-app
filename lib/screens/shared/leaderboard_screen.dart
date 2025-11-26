import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  Stream<List<Map<String, dynamic>>> fetchUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('points', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              "name": data['name'] ?? "",
              "points": data['points'] ?? 0,
              "initials": getInitials(data['name'] ?? ""),
            };
          }).toList(),
        );
  }

  static String getInitials(String name) {
    final parts = name.split(" ");
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Leaderboard"),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          if (users.isEmpty) {
            return const Center(child: Text("No users available"));
          }

          // Top 3
          final top3 = users.take(3).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Top Students",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // Top 3 section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (top3.length > 1)
                      _TopRank(
                        initials: top3[1]['initials'],
                        rank: "2nd",
                        color: Colors.grey,
                      ),
                    _TopRank(
                      initials: top3[0]['initials'],
                      rank: "1st",
                      color: Colors.orange,
                    ),
                    if (top3.length > 2)
                      _TopRank(
                        initials: top3[2]['initials'],
                        rank: "3rd",
                        color: Colors.blueGrey,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Student List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final student = users[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              student["initials"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              student["name"],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            "${student['points']} pts",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Widget for Top 3
class _TopRank extends StatelessWidget {
  final String initials;
  final String rank;
  final Color color;
  

  const _TopRank({
    required this.initials,
    required this.rank,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(rank, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
