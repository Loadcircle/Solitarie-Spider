import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 0.85,
          colors: [Color(0xFF1E5E2A), Color(0xFF0A1A0E)],
        ),
      ),
      child: child,
    );
  }
}
