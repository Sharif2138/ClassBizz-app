import 'package:flutter/material.dart';

class JoinSessionScreen extends StatefulWidget {
  const JoinSessionScreen({super.key});

  @override
  State<JoinSessionScreen> createState() => _JoinSessionScreenState();
}

class _JoinSessionScreenState extends State<JoinSessionScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorText;
  bool _isJoining = false;

  final List<_QuickClass> _quickClasses = const [
    _QuickClass(code: 'ADF301', title: 'Advanced Frontend Dev', status: 'Active'),
    _QuickClass(code: 'CS401', title: 'Data Structures', status: 'Active'),
  ];

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleJoin() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        _errorText = 'Please enter a class code';
      });
      return;
    }

    setState(() {
      _isJoining = true;
      _errorText = null;
    });

    // TODO: integrate with backend / Firebase
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isJoining = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined session: $code')),
      );
    }
  }

  void _handleQuickJoin(String code) {
    _codeController.text = code;
    _handleJoin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NOTE: no bottomNavigationBar here
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: 'Start Class',
              onBack: () => Navigator.pop(context),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _JoinCard(
                      controller: _codeController,
                      errorText: _errorText,
                      isJoining: _isJoining,
                      onJoin: _handleJoin,
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Quick Access',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final item in _quickClasses)
                      _QuickAccessTile(
                        code: item.code,
                        title: item.title,
                        status: item.status,
                        onTap: () => _handleQuickJoin(item.code),
                      ),
                    const SizedBox(height: 40),
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

class _JoinCard extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final VoidCallback onJoin;
  final bool isJoining;

  const _JoinCard({
    required this.controller,
    required this.errorText,
    required this.onJoin,
    required this.isJoining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E8EC)),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFE9F0FF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.tag_outlined,
                color: Color(0xFF5E86FF),
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter Class Code',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Start your class session with the\nclass code',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onJoin(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'e.g., MATH301',
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                errorText!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isJoining ? null : onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E86FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: isJoining
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Start Class',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  final String code;
  final String title;
  final String status;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.code,
    required this.title,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFE9F0FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.people_alt_outlined, color: Color(0xFF5E86FF)),
        ),
        title: Text(
          code,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, size: 18, color: Color(0xFF5E86FF)),
            const SizedBox(width: 4),
            Text(
              status,
              style: const TextStyle(
                color: Color(0xFF5E86FF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickClass {
  final String code;
  final String title;
  final String status;

  const _QuickClass({
    required this.code,
    required this.title,
    required this.status,
  });
}

