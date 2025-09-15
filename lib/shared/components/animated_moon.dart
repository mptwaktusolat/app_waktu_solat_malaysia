import 'package:flutter/material.dart';

class AnimatedMoon extends StatelessWidget {
  AnimatedMoon({
    super.key,
    this.width,
    this.isDarkMode,
    AnimationController? animationController,
  }) : _animationController = animationController;

  final double? width;
  final bool? isDarkMode;
  final AnimationController? _animationController;

  // moon animation swatches (light)
  final List<Color> lightSwatches = [
    const Color(0xDDFF0080),
    const Color(0xDDFF8C00),
  ];

  // moon animation swatches (dark)
  final List<Color> darkSwatches = [
    const Color(0xFF8983F7),
    const Color(0xFFA3DAFB),
  ];

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.6,
      child: Stack(
        children: <Widget>[
          Container(
            width: width! * 0.35,
            height: width! * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isDarkMode! ? darkSwatches : lightSwatches,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(40, 0),
            child: ScaleTransition(
              scale: _animationController!.drive(
                Tween<double>(begin: 0.0, end: 1.0).chain(
                  CurveTween(curve: Curves.decelerate),
                ),
              ),
              alignment: Alignment.topRight,
              child: Container(
                width: width! * 0.26,
                height: width! * 0.26,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
