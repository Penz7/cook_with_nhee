import 'package:flutter/material.dart';

import '../../style/colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [UIColors.primaryColorFade, UIColors.secondaryColorFade],
          stops: [0, 1],
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomCenter,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: body,
    );
  }
}
