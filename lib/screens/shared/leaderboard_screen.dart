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
    final themeColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
    

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

          final top3 = users.take(3).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Top Students",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 10),

              // Top 3 podium
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (top3.length > 1)
                      _TopRank(
                        initials: top3[1]['initials'],
                        rank: "2nd",
                        color: Colors.grey.shade500,
                        size: 65,
                        offset: 10,
                      ),
                    _TopRank(
                      initials: top3[0]['initials'],
                      rank: "1st",
                      color: Colors.amber.shade600,
                      size: 80,
                      offset: 0,
                    ),
                    if (top3.length > 2)
                      _TopRank(
                        initials: top3[2]['initials'],
                        rank: "3rd",
                        color: Colors.brown.shade400,
                        size: 65,
                        offset: 10,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // List of all users
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final student = users[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: themeColor,
                            child: Text(
                              student["initials"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Text(
                              student["name"],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${student['points']} pts",
                              style: TextStyle(
                                color: themeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

// Redesigned Top Rank Podium Widget
class _TopRank extends StatelessWidget {
  final String initials;
  final String rank;
  final Color color;
  final double size;
  final double offset;

  const _TopRank({
    required this.initials,
    required this.rank,
    required this.color,
    this.size = 70,
    this.offset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          rank,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: offset),
        CircleAvatar(
          radius: size / 2,
          backgroundColor: color,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }
}
