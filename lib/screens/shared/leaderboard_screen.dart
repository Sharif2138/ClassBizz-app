import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for students
    final List<Map<String, dynamic>> students = [
      {"name": "Alex Johnson", "initials": "AJ", "points": 92, "rank": 1},
      {"name": "John Doe", "initials": "JD", "points": 85, "rank": 2},
      {"name": "Grace Smith", "initials": "GS", "points": 78, "rank": 3},
      {"name": "Emma Davis", "initials": "ED", "points": 75, "rank": 4},
      {"name": "Mike Chen", "initials": "MC", "points": 73, "rank": 5},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Leaderboard",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F68FF),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 3 Highlights
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
 gradient: LinearGradient(
              colors: [Color(0xFF0F68FF), Color(0xFF01B67A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
               ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'TOP PERFORMERS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _TopRank(
                      initials: "JD",
                      rank: "2nd",
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 192, 192, 192), // Silver
                          Color.fromARGB(255, 230, 230, 230), // Light silver
                          Colors.white, // White
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    _TopRank(
                      initials: "AJ",
                      rank: "1st",
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 212, 175, 55), // Gold
                          Color.fromARGB(255, 255, 215, 0), // Light gold
                          Colors.white, // White
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    _TopRank(
                      initials: "GS",
                      rank: "3rd",
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 205, 127, 50), // Bronze
                          Color.fromARGB(255, 210, 180, 140), // Light bronze
                          Colors.white, // White
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                const Text(
                  "RANK",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                const Text(
                  "POINTS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // Student List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final rank = student["rank"];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _getRankColor(rank),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            rank.toString(),
                            style: TextStyle(
                              color: _getRankTextColor(rank),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Avatar with gradient
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue[600]!,
                              Colors.purple[500]!,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            student["initials"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student["name"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Rank #${student["rank"]}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${student['points']} pts",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.blue[800],
                            fontSize: 14,
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
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color.fromARGB(255, 255, 218, 7).withOpacity(0.2);
      case 2:
        return const Color.fromARGB(255, 231, 228, 12).withOpacity(0.2);
      case 3:
        return const Color.fromARGB(255, 187, 255, 0).withOpacity(0.2);
      default:
        return const Color.fromARGB(255, 243, 61, 61).withOpacity(0.1);
    }
  }

  Color _getRankTextColor(int rank) {
    switch (rank) {
      case 1:
        return const Color.fromARGB(255, 255, 218, 7);
      case 2:
        return const Color.fromARGB(255, 231, 228, 12);
      case 3:
        return const Color.fromARGB(255, 187, 255, 0);
      default:
        return const Color.fromARGB(255, 248, 36, 36);
    }
  }
}

// Updated widget for Top 3 section with gradient support
class _TopRank extends StatelessWidget {
  final String initials;
  final String rank;
  final Gradient gradient;

  const _TopRank({
    required this.initials,
    required this.rank,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFirst = rank == "1st";

    return Column(
      children: [
        Text(rank, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0),
              width: 3.0,
            ),
          ),
          child: Container(
            width: (isFirst ? 50 : 28) * 2,
            height: (isFirst ? 50 : 28) * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: const Color.fromARGB(255, 2, 1, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: isFirst ? 25 : 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}