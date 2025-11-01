import 'package:flutter/material.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // If your app already has a shared bottom nav, remove this bottomNavigationBar
      bottomNavigationBar: _StudentBottomNavBar(currentIndex: 0),
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _DashboardHeader(),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 16),
            ),
            SliverToBoxAdapter(
              child: _QuickActionsCard(
                onStartClass: () {
                  // TODO: navigate to join/start session screen
                  // Navigator.pushNamed(context, '/student/join');
                },
                onLeaderboard: () {
                  // TODO: navigate to leaderboard screen
                  // Navigator.pushNamed(context, '/student/leaderboard');
                },
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 24),
            ),
            SliverToBoxAdapter(
              child: _RecentActivityHeader(
                onViewAll: () {
                  // TODO: navigate to recent / history screen
                  // Navigator.pushNamed(context, '/student/history');
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                const [
                  _RecentActivityTile(
                    title: 'Advanced Frontend Dev',
                    studentsCount: 28,
                    status: ActivityStatus.completed,
                    timeText: '2 hours ago',
                  ),
                  _RecentActivityTile(
                    title: 'Data Structures',
                    studentsCount: 32,
                    status: ActivityStatus.upcoming,
                    timeText: 'Tomorrow 10:00 AM',
                  ),
                  _RecentActivityTile(
                    title: 'Computer Networks',
                    studentsCount: 25,
                    status: ActivityStatus.upcoming,
                    timeText: 'Wednesday 2:00 PM',
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// HEADER
/// ---------------------------------------------------------------------------
class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // gradient background
        Container(
          height: 210,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F68FF),
                Color(0xFF01B67A),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(26),
              bottomRight: Radius.circular(26),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // avatar
                      const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                    Icons.person,
                    color: Color(0xFF0F68FF),
                    ),
                    ),

                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Alex!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Student',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // notification icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // stats cards row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StatCard(
                    icon: Icons.calendar_month_rounded,
                    title: 'Active Classes',
                    value: '3',
                  ),
                  _StatCard(
                    icon: Icons.people_alt_outlined,
                    title: 'Total Students',
                    value: '85',
                  ),
                  _StatCard(
                    icon: Icons.schedule_rounded,
                    title: 'This Week',
                    value: '7',
                  ),
                ],
              ),
            ],
          ),
        ),
        // white card overlap
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: Container(), // the quick actions card will sit under
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// QUICK ACTIONS
/// ---------------------------------------------------------------------------
class _QuickActionsCard extends StatelessWidget {
  final VoidCallback onStartClass;
  final VoidCallback onLeaderboard;

  const _QuickActionsCard({
    required this.onStartClass,
    required this.onLeaderboard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 6),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onStartClass,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F68FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Start Class',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onLeaderboard,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFE5E8EC),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.emoji_events_outlined,
                              color: Color(0xFF0F68FF), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Leaderboard',
                            style: TextStyle(
                              color: Color(0xFF0F68FF),
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// RECENT ACTIVITY
/// ---------------------------------------------------------------------------
class _RecentActivityHeader extends StatelessWidget {
  final VoidCallback onViewAll;

  const _RecentActivityHeader({required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'View All',
              style: TextStyle(
                color: Color(0xFF0F68FF),
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}

enum ActivityStatus { completed, upcoming }

class _RecentActivityTile extends StatelessWidget {
  final String title;
  final int studentsCount;
  final ActivityStatus status;
  final String timeText;

  const _RecentActivityTile({
    required this.title,
    required this.studentsCount,
    required this.status,
    required this.timeText,
  });

  Color get _statusColor {
    switch (status) {
      case ActivityStatus.completed:
        return const Color(0xFF0F68FF);
      case ActivityStatus.upcoming:
        return const Color(0xFF19C37D);
    }
  }

  String get _statusText {
    switch (status) {
      case ActivityStatus.completed:
        return 'completed';
      case ActivityStatus.upcoming:
        return 'upcoming';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // main text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$studentsCount students',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _statusText,
                  style: TextStyle(
                    color: _statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                timeText,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// BOTTOM NAV (simple placeholder to match Figma)
/// ---------------------------------------------------------------------------
class _StudentBottomNavBar extends StatelessWidget {
  final int currentIndex;
  const _StudentBottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // TODO: hook to your main navigation
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
