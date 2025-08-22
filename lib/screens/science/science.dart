import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ScienceSubjectsPage extends StatefulWidget {
  const ScienceSubjectsPage({super.key});

  @override
  State<ScienceSubjectsPage> createState() => _ScienceSubjectsPageState();
}

class _ScienceSubjectsPageState extends State<ScienceSubjectsPage> {
  int? _hoveredIndex;
  int? _selectedIndex;

  // Update the routes to match your router if you use different paths.
  final _subjects = const [
    _Subject(
      title: 'MATHEMATICS',
      desc:
          'Detailed explanations of complex mathematical theories and formulas.\n'
          'Practice exercises and quizzes.',
      route: '/subject/maths',
    ),
    _Subject(
      title: 'LIFE SCIENCES',
      desc:
          'Explanations of biological concepts and processes.\n'
          'Practice exercises and quizzes.',
      route: '/subject/life-sciences',
    ),
    _Subject(
      title: 'PHYSICAL SCIENCES',
      desc:
          'Explore physics and chemistry.\n'
          'Practice exercises and quizzes.',
      route: '/subject/physical-sciences',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // light grey background like the reference
      backgroundColor: const Color(0xFFF2F3F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'SCIENCE',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // cards
                  for (int i = 0; i < _subjects.length; i++) ...[
                    _SubjectTile(
                      subject: _subjects[i],
                      active: _selectedIndex == i || _hoveredIndex == i,
                      onEnter: (_) => setState(() => _hoveredIndex = i),
                      onExit: (_) => setState(() => _hoveredIndex = null),
                      onTap: () {
                        setState(() => _selectedIndex = i);
                        // small delay so the user sees the selection effect
                        Future.delayed(const Duration(milliseconds: 120), () {
                          context.go(_subjects[i].route);
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Subject {
  final String title;
  final String desc;
  final String route;
  const _Subject({
    required this.title,
    required this.desc,
    required this.route,
  });
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({
    required this.subject,
    required this.active,
    required this.onTap,
    this.onEnter,
    this.onExit,
  });

  final _Subject subject;
  final bool active;
  final VoidCallback onTap;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  @override
  Widget build(BuildContext context) {
    final bg = active ? Colors.black : Colors.white;
    final border = active ? Colors.black : Colors.black.withOpacity(0.08);
    final titleColor = active ? Colors.white : Colors.black87;
    final bodyColor = active ? Colors.white70 : Colors.black54;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(active ? 0.35 : 0.12),
            blurRadius: active ? 18 : 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subject.desc,
            style: TextStyle(fontSize: 15, height: 1.35, color: bodyColor),
          ),
        ],
      ),
    );

    // Hover works on web/desktop; on mobile it’s ignored (tap still works).
    final wrapped = kIsWeb
        ? MouseRegion(onEnter: onEnter, onExit: onExit, child: card)
        : card;

    return GestureDetector(onTap: onTap, child: wrapped);
  }
}
