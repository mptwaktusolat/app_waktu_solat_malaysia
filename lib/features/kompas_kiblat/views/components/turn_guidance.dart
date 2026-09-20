part of '../qibla_compass.dart';

class _TurnGuidance extends StatelessWidget {
  const _TurnGuidance({required this.controller});

  final QiblaCompassController controller;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final turn = controller.turnDegrees!;
    final String message;
    final IconData icon;

    if (controller.isAligned) {
      message = localizations.qiblaAligned;
      icon = Icons.check_circle_outline;
    } else if (turn > 0) {
      message = localizations.qiblaTurnRight(turn.abs().round());
      icon = Icons.rotate_right;
    } else {
      message = localizations.qiblaTurnLeft(turn.abs().round());
      icon = Icons.rotate_left;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: controller.isAligned ? Colors.green : colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: controller.isAligned ? Colors.green : null),
          ),
        ),
      ],
    );
  }
}
