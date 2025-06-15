import 'package:flutter/material.dart';

/// Widget for individual Tasbih bead
class TasbihBead extends StatelessWidget {
  const TasbihBead({
    super.key,
    required this.gradientColor,
  });

  final List<Color> gradientColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColor,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
