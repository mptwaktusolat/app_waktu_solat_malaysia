part of '../qibla_compass.dart';

class _LocationAndBearing extends StatelessWidget {
  const _LocationAndBearing({required this.location, required this.bearing});

  final String location;
  final double bearing;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final roundedBearing = bearing.round() % 360;

    return Semantics(
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  location,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            localizations.qiblaHeadingDegrees(roundedBearing),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
