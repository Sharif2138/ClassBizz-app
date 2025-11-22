import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for students
    final List<Map<String, dynamic>> students = [
      {"name": "Alex Johnson", "initials": "AJ", "points": 92},
      {"name": "John Doe", "initials": "JD", "points": 85},
      {"name": "Grace Smith", "initials": "GS", "points": 78},
      {"name": "Emma Davis", "initials": "ED", "points": 75},
      {"name": "Mike Chen", "initials": "MC", "points": 73},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Leaderboard"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title Section
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Top Students",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Top 3 Highlights
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _TopRank(initials: "JD", rank: "2nd", color: Colors.grey),
                _TopRank(initials: "AJ", rank: "1st", color: Colors.orange),
                _TopRank(initials: "GS", rank: "3rd", color: Colors.blueGrey),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Student List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];

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
      ),
    );
  }
}

// Small widget for Top 3 section
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
