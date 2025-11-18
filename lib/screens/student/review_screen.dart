import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final int _maxChars = 500;

  final List<_FeedbackTag> _tags = [
    _FeedbackTag(icon: Icons.check_circle_outline, label: 'Clear explanations'),
    _FeedbackTag(icon: Icons.lightbulb_outline, label: 'Engaging content'),
    _FeedbackTag(icon: Icons.speed, label: 'Pace was good'),
    _FeedbackTag(icon: Icons.slow_motion_video, label: 'Pace too fast'),
    _FeedbackTag(icon: Icons.menu_book_outlined, label: 'More examples needed'),
    _FeedbackTag(icon: Icons.shield_moon_outlined, label: 'Felt safe to speak'),
  ];

  bool _submitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _onStarTap(int value) {
    setState(() {
      _selectedRating = value;
    });
  }

  Future<void> _handleSubmit() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please rate the class before submitting.'),
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    // TODO: send to backend / Firebase
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _submitting = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted. Thank you!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _feedbackController.text.length;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      // NOTE: no bottomNavigationBar
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: 'Class Review',
              onBack: () => Navigator.pop(context),
            ),
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
                      courseTitle: 'Mathematics III - Calculus',
                      lecturerName: 'Dr. Sarah',
                      sessionCode: 'MATH301A',
                      sessionDate: '10/5/2025',
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      "How was today's class?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _RatingBar(selected: _selectedRating, onTap: _onStarTap),
                    const SizedBox(height: 6),
                    Text(
                      _selectedRating == 0
                          ? 'Tap a star to rate'
                          : 'You rated $_selectedRating / 5',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Share your thoughts (optional)',
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
                        maxLength: _maxChars,
                        decoration: const InputDecoration(
                          hintText:
                              'What did you enjoy? Any suggestions for improvement?',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          counterText: '',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$selectedCount/$_maxChars characters',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Quick feedback',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _tags
                          .map(
                            (tag) => FilterChip(
                              label: Text(tag.label),
                              avatar: Icon(
                                tag.icon,
                                size: 16,
                                color: tag.selected
                                    ? Colors.white
                                    : const Color(0xFF0F68FF),
                              ),
                              selected: tag.selected,
                              selectedColor: const Color(0xFF0F68FF),
                              checkmarkColor: Colors.white,
                              onSelected: (val) {
                                setState(() {
                                  tag.selected = val;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F68FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Submit Review',
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
  final VoidCallback onBack;

  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
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
            'with $lecturerName',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            'Session: $sessionCode • $sessionDate',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;

  const _RatingBar({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isSelected = starIndex <= selected;
        return IconButton(
          onPressed: () => onTap(starIndex),
          icon: Icon(
            isSelected ? Icons.star_rounded : Icons.star_border_rounded,
            size: 34,
            color: isSelected ? const Color(0xFFFFC940) : Colors.grey.shade400,
          ),
        );
      }),
    );
  }
}

class _FeedbackTag {
  final IconData icon;
  final String label;
  bool selected;

  _FeedbackTag({
    required this.icon,
    required this.label,
    this.selected = false,
  });
}
