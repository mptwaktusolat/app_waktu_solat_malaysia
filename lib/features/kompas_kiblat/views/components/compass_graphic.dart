part of '../qibla_compass.dart';

class _CompassGraphic extends StatelessWidget {
  const _CompassGraphic(
      {required this.rotationDegrees, required this.isAligned});

  final double rotationDegrees;
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = isAligned ? Colors.green : colorScheme.primary;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedRotation(
          turns: rotationDegrees / 360,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: SvgPicture.asset(
            'assets/qibla/compass.svg',
            colorFilter: ColorFilter.mode(indicatorColor, BlendMode.srcIn),
          ),
        ),
        SvgPicture.asset('assets/qibla/kaaba.svg'),
        SvgPicture.asset(
          'assets/qibla/needle.svg',
          colorFilter: ColorFilter.mode(
            colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
