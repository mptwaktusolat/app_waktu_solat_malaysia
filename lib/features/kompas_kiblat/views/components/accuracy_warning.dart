part of '../qibla_compass.dart';

class _AccuracyWarning extends StatelessWidget {
  const _AccuracyWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: 17,
            color: colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colorScheme.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
