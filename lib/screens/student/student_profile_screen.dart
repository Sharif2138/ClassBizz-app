import 'package:flutter/material.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      // NOTE: no bottomNavigationBar here
      body: SafeArea(
        child: Column(
          children: [
            const _ProfileTopBar(),
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
                    const _ProfileHeader(),
                    const SizedBox(height: 18),
                    const _StatsRow(),
                    const SizedBox(height: 24),
                    const Text(
                      'Recent Sessions',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _SessionHistoryTile(
                      title: 'Advanced Frontend Dev',
                      date: '10 Oct 2025',
                      points: 45,
                      status: 'completed',
                    ),
                    const _SessionHistoryTile(
                      title: 'Data Structures',
                      date: '09 Oct 2025',
                      points: 32,
                      status: 'completed',
                    ),
                    const _SessionHistoryTile(
                      title: 'Computer Networks',
                      date: '06 Oct 2025',
                      points: 20,
                      status: 'missed',
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Achievements',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _BadgeChip(label: 'Top 10 this week'),
                        _BadgeChip(label: '5 classes in a row'),
                        _BadgeChip(label: 'High participation'),
                      ],
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

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          const Text(
            'Profile',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundColor: Color(0xFF0F68FF),
          child: Icon(Icons.person, color: Colors.white, size: 34),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alex Johnson',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Text(
              'Student • ALU Kigali',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Icon(
                  Icons.shield_moon_outlined,
                  color: Colors.grey.shade500,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Member since 2025',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            title: 'Total Points',
            value: '132',
            subtitle: 'All sessions',
            icon: Icons.leaderboard_outlined,
            color: Color(0xFF0F68FF),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Sessions Joined',
            value: '14',
            subtitle: 'Last 30 days',
            icon: Icons.school_outlined,
            color: Color(0xFF19C37D),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Rank',
            value: '#08',
            subtitle: 'This course',
            icon: Icons.star_border_rounded,
            color: Color(0xFFFFC940),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _SessionHistoryTile extends StatelessWidget {
  final String title;
  final String date;
  final int points;
  final String status;

  const _SessionHistoryTile({
    required this.title,
    required this.date,
    required this.points,
    required this.status,
  });

  Color get _statusColor {
    if (status == 'completed') return const Color(0xFF19C37D);
    if (status == 'missed') return const Color(0xFFFF7A7A);
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFE9F0FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.book_outlined, color: Color(0xFF0F68FF)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          date,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '+$points pts',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: _statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  const _BadgeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E8EC)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
