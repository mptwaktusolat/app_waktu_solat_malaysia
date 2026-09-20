part of '../qibla_compass.dart';

class _ReadyCompass extends StatelessWidget {
  const _ReadyCompass({required this.controller});

  final QiblaCompassController controller;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final details = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (controller.shouldShowOutsideMalaysiaWarning) ...[
          PastelAdmonition.caution(
            text: localizations.qiblaOutsideMalaysiaWarning,
          ),
          const SizedBox(height: 8),
        ],
        _LocationAndBearing(
          location:
              controller.locationLabel ?? localizations.qiblaUnknownLocation,
          bearing: controller.qiblaBearing!,
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final content = constraints.maxHeight < 360
              ? Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: SingleChildScrollView(child: details),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: _buildDirectionalContent(context),
                    ),
                  ],
                )
              : Column(
                  children: [
                    details,
                    const SizedBox(height: 8),
                    Expanded(child: _buildDirectionalContent(context)),
                  ],
                );

          return Column(
            children: [
              Expanded(child: content),
              if (controller.displayTurnDegrees != null) ...[
                const SizedBox(height: 8),
                _CompassAccuracyIndicator(
                  accuracy: controller.headingAccuracyLevel,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildDirectionalContent(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (controller.status == QiblaCompassStatus.noSensor) {
      return const NoCompassSensor();
    }
    if (controller.status == QiblaCompassStatus.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.explore_off_outlined,
              size: 72,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.qiblaCompassError,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: controller.retry,
              child: Text(localizations.qiblaRetry),
            ),
          ],
        ),
      );
    }
    if (controller.sensorAvailable == null ||
        controller.displayTurnDegrees == null) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        return Center(
          child: SizedBox.square(
            dimension: size,
            child: _CompassGraphic(
              rotationDegrees: controller.displayTurnDegrees!,
              isAligned: controller.isAligned,
            ),
          ),
        );
      },
    );
  }
}
