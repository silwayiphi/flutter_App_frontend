import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StreamSelectionPage extends StatelessWidget {
  const StreamSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // deep, professional dark background
      backgroundColor: const Color(0xFF0B0D12),
      body: Stack(
        children: [
          // gradient wash
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F1218), Color(0xFF0A0C12)],
              ),
            ),
          ),

          // soft floating blobs (pure decor)
          const _Blob(top: -40, left: -30, size: 160, color: Color(0xFF69E1FF)),
          const _Blob(
            top: 120,
            right: -30,
            size: 120,
            color: Color(0xFFB9A8FF),
          ),
          const _Blob(
            bottom: -20,
            left: 40,
            size: 90,
            color: Color(0xFF78FFC2),
            opacity: .6,
          ),

          // content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 4),
                      // pill title (like your mock)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(.25),
                            width: 1.4,
                          ),
                          color: Colors.white.withOpacity(.04),
                        ),
                        child: const Text(
                          'CHOOSE STREAM',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      const SizedBox(height: 26),

                      // vertical glass cards
                      _GlassStreamCard(
                        title: 'SCIENCE',
                        onSelect: () => context.go('/science'),
                      ),
                      const SizedBox(height: 18),
                      _GlassStreamCard(
                        title: 'HISTORY',
                        onSelect: () => context.go('/streams/history'),
                      ),
                      const SizedBox(height: 18),
                      _GlassStreamCard(
                        title: 'COMMERCE',
                        onSelect: () => context.go('/streams/commerce'),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassStreamCard extends StatelessWidget {
  const _GlassStreamCard({required this.title, required this.onSelect});

  final String title;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final border = Colors.white.withOpacity(.18);
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14), // glass blur
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border, width: 1.2),
            color: Colors.white.withOpacity(.06), // frosted layer
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.35),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: .5,
                ),
              ),
              const SizedBox(height: 16),

              // gradient select button
              _GradientButton(label: 'SELECT', onTap: onSelect),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF69E1FF), Color(0xFFB9A8FF)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: gradient,
          ),
          child: const Center(
            child: Text(
              'SELECT',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
    this.opacity = .35,
  });

  final double? top, left, right, bottom;
  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(opacity * .6),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
