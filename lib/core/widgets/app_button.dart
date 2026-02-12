import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.isGold = false,
  });

  final IconData? icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isGold;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isGold
              ? const [
                  Color.fromARGB(255, 233, 193, 63), // gold top
                  Color.fromARGB(255, 190, 143, 0), // gold bottom
                ]
              : isPrimary
                  ? const [Color(0xFF4CAF50), Color(0xFF2E7D32)]
                  : const [Color(0xFF3A4A3E), Color(0xFF2A3530)],
              ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isGold
              ? const Color(0xFFFFE082)
              : isPrimary
                  ? const Color(0xFF5CAF60)
                  : const Color(0xFF4A5A4E),
              ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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
