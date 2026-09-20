part of '../qibla_compass.dart';

class _CompassAccuracyIndicator extends StatelessWidget {
  const _CompassAccuracyIndicator({required this.accuracy});

  final QiblaHeadingAccuracy accuracy;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final (label, containerColor, foregroundColor) = switch (accuracy) {
      QiblaHeadingAccuracy.high => (
          localizations.qiblaAccuracyHigh,
          colorScheme.secondaryContainer,
          colorScheme.onSecondaryContainer,
        ),
      QiblaHeadingAccuracy.medium => (
          localizations.qiblaAccuracyMedium,
          colorScheme.tertiaryContainer,
          colorScheme.onTertiaryContainer,
        ),
      QiblaHeadingAccuracy.low => (
          localizations.qiblaAccuracyLow,
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
        ),
      QiblaHeadingAccuracy.unavailable => (
          localizations.qiblaAccuracyUnavailable,
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
        ),
    };

    return Semantics(
      container: true,
      liveRegion: true,
      label: '${localizations.qiblaCompassAccuracy}: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Icon(
              Icons.compass_calibration_outlined,
              size: 18,
              color: foregroundColor,
            ),
            Text(
              '${localizations.qiblaCompassAccuracy}: $label',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (accuracy.shouldCalibrate)
              TextButton(
                onPressed: () => showCompassCalibrationDialog(context),
                style: TextButton.styleFrom(
                  foregroundColor: foregroundColor,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(localizations.qiblaCalibrateNow),
              ),
          ],
        ),
      ),
    );
  }
}
