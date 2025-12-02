import 'package:flutter/material.dart';

import '../../style/colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Soft pink card background to match app theme
        gradient: LinearGradient(
          colors: [
            Colors.pink.shade50,
            Colors.pink.shade100.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade100.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: body,
    );
  }
}
