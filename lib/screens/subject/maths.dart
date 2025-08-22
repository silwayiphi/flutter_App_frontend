import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MathsPage extends StatelessWidget {
  const MathsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // <- new light background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Black pill title
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Text(
                        'MATHEMATICS',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // PAPER ONE — light card
                  _PaperSection(
                    title: 'PAPER  ONE',
                    isDark: false, // white card, black text
                    items: const [
                      _TopicItem('Algebra, Equations and Inequalities',
                          '/subject/maths/topic/algebra-equations-inequalities'),
                      _TopicItem('Number Patterns',
                          '/subject/maths/topic/number-patterns'),
                      _TopicItem('Functions and Graphs',
                          '/subject/maths/topic/functions-graphs'),
                      _TopicItem('Finance, Growth and Decay',
                          '/subject/maths/topic/finance-growth-decay'),
                      _TopicItem('Differential Calculus',
                          '/subject/maths/topic/differential-calculus'),
                      _TopicItem('Counting Principle and Probability',
                          '/subject/maths/topic/counting-principle-probability'),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // PAPER TWO — dark card
                  _PaperSection(
                    title: 'PAPER  TWO',
                    isDark: true, // black card, white text
                    items: const [
                      _TopicItem('Statistics and Regression',
                          '/subject/maths/topic/statistics-regression'),
                      _TopicItem('Analytical Geometry',
                          '/subject/maths/topic/analytical-geometry'),
                      _TopicItem('Trigonometry',
                          '/subject/maths/topic/trigonometry'),
                      _TopicItem('Euclidean Geometry',
                          '/subject/maths/topic/euclidean-geometry'),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // EXAMS button — black pill
                  SizedBox(
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 8,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () => context.go('/subject/maths/exams'),
                      child: const Text('EXAMS'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaperSection extends StatelessWidget {
  const _PaperSection({
    required this.title,
    required this.items,
    required this.isDark,
  });

  final String title;
  final List<_TopicItem> items;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? Colors.black : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final border = isDark ? Colors.transparent : Colors.black87;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border, width: isDark ? 0 : 1.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < items.length; i++) ...[
            _NumberedTile(
              index: i + 1,
              label: items[i].label,
              onTap: () => context.go(items[i].route),
              // for light card use dark badge (black), for dark card use light badge (white)
              darkBadge: !isDark ? true : false,
              textColor: isDark ? Colors.white : Colors.black87,
            ),
            if (i != items.length - 1)
              const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _NumberedTile extends StatelessWidget {
  const _NumberedTile({
    required this.index,
    required this.label,
    required this.textColor,
    this.onTap,
    this.darkBadge = true,
  });

  final int index;
  final String label;
  final Color textColor;
  final VoidCallback? onTap;
  final bool darkBadge;

  @override
  Widget build(BuildContext context) {
    final badgeBg = darkBadge ? Colors.black : Colors.white;
    final badgeFg = darkBadge ? Colors.white : Colors.black87;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // number badge
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: darkBadge ? Colors.transparent : Colors.black12,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: TextStyle(color: badgeFg, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 10),
            // label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicItem {
  final String label;
  final String route;
  const _TopicItem(this.label, this.route);
}
