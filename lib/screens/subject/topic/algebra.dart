import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlgebraHubPage extends StatelessWidget {
  const AlgebraHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F1016);        // page bg
    const card = Color(0xFF14141D);      // dark card
    const lilac = Color(0xFFE7D9FF);     // icon bubble
    const divider = Color(0xFFE7D9FF);   // thin lilac line

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'ALGEBRA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    _RowItem(
                      icon: Icons.note_rounded,
                      label: 'NOTES',
                      onTap: () => context.go(
                        '/subject/maths/topic/algebra-equations-inequalities/notes',
                      ),
                    ),
                    const _SoftDivider(color: lilac),

                    _RowItem(
                      icon: Icons.edit_rounded,
                      label: 'ASSIGNMENTS',
                      onTap: () => context.go(
                        '/subject/maths/topic/algebra-equations-inequalities/assignments',
                      ),
                    ),
                    const _SoftDivider(color: lilac),

                    _RowItem(
                      icon: Icons.query_stats_rounded,
                      label: 'QUIZ',
                      onTap: () => context.go(
                        '/subject/maths/topic/algebra-equations-inequalities/quiz',
                      ),
                    ),
                    const _SoftDivider(color: lilac),

                    _RowItem(
                      icon: Icons.videocam_rounded,
                      label: 'VIDEOS',
                      onTap: () => context.go(
                        '/subject/maths/topic/algebra-equations-inequalities/videos',
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const lilac = Color(0xFFE7D9FF);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // circular icon bubble
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: lilac,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black87, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: .6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _SoftDivider extends StatelessWidget {
  const _SoftDivider({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 68, right: 4), // align under labels
      height: 1,
      color: color.withOpacity(.35),
    );
  }
}
