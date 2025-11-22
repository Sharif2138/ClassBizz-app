import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(title: "Class Review"),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SessionSummaryCard(
                      courseTitle: "Mathematics III - Calculus",
                      lecturerName: "Dr. Sarah",
                      sessionCode: "MATH301A",
                      sessionDate: "10/5/2025",
                    ),

                    const SizedBox(height: 26),

                    // Rating section
                    const Text(
                      "How was today's class?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _RatingBar(),
                    const SizedBox(height: 6),
                    Text(
                      "Tap a star to rate",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Text feedback
                    const Text(
                      "Share your thoughts (optional)",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF3F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText:
                              "What did you enjoy? Any suggestions for improvement?",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quick feedback tags
                    const Text(
                      "Quick feedback",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _FeedbackChip(
                          icon: Icons.check_circle_outline,
                          label: "Clear explanations",
                        ),
                        _FeedbackChip(
                          icon: Icons.lightbulb_outline,
                          label: "Engaging content",
                        ),
                        _FeedbackChip(
                          icon: Icons.speed,
                          label: "Pace was good",
                        ),
                        _FeedbackChip(
                          icon: Icons.slow_motion_video,
                          label: "Pace too fast",
                        ),
                        _FeedbackChip(
                          icon: Icons.menu_book_outlined,
                          label: "More examples needed",
                        ),
                        _FeedbackChip(
                          icon: Icons.shield_moon_outlined,
                          label: "Felt safe to speak",
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Submit button (UI only)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F68FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 42),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;

  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SessionSummaryCard extends StatelessWidget {
  final String courseTitle;
  final String lecturerName;
  final String sessionCode;
  final String sessionDate;

  const _SessionSummaryCard({
    required this.courseTitle,
    required this.lecturerName,
    required this.sessionCode,
    required this.sessionDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF1FF), Color(0xFFE2FFF3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseTitle,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            "with $lecturerName",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            "Session: $sessionCode • $sessionDate",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (_) {
        return Icon(
          Icons.star_border_rounded,
          size: 34,
          color: Colors.grey.shade400,
        );
      }),
    );
  }
}

class _FeedbackChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeedbackChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: const Color(0xFF0F68FF)),
      selected: false,
      onSelected: (_) {},
      selectedColor: const Color(0xFF0F68FF),
      checkmarkColor: Colors.white,
    );
  }
}
