import 'package:classbizz_app/screens/student/student_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classbizz_app/providers/review_provider.dart';

class ReviewScreen extends StatefulWidget {
  final String sessionId;
  final String lecturerId;

  const ReviewScreen({
    super.key,
    required this.sessionId,
    required this.lecturerId,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = context.watch<ReviewProvider>();

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
                    const SizedBox(height: 18),
                    const Text(
                      "How was today's class?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RatingBar(
                      onRatingSelected: (int rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Tap a star to rate",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "Share your thoughts",
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
                      child: TextField(
                        controller: _feedbackController,
                        maxLines: 5,
                        decoration: const InputDecoration(
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
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: reviewProvider.isLoading
                            ? null
                            : () async {
                                if (_rating == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please select a rating before submitting.",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  await reviewProvider.submitReview(
                                    sessionId: widget.sessionId,
                                    lecturerId: widget.lecturerId,
                                    rating: _rating,
                                    description: _feedbackController.text,
                                  );

                                  if (mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const StudentBottomNav(),
                                      ),
                                    );
                                  }
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to submit review: $error',
                                      ),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F68FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: reviewProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
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

// ---------------- Top Bar ----------------
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

// ---------------- Rating Bar ----------------
class RatingBar extends StatefulWidget {
  final void Function(int) onRatingSelected;

  const RatingBar({super.key, required this.onRatingSelected});

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = starIndex;
            });
            widget.onRatingSelected(_currentRating);
          },
          child: Icon(
            starIndex <= _currentRating
                ? Icons.star
                : Icons.star_border_rounded,
            size: 34,
            color: Colors.orange,
          ),
        );
      }),
    );
  }
}
