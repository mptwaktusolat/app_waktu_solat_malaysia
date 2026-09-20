import 'package:admonitions/admonitions.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'qibla_compass.dart';

/// Entry point for the Qibla page
class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.qiblaTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > constraints.maxHeight) {
              return _buildHorizontalLayout(context);
            }
            return _buildVerticalLayout(context);
          },
        ),
      ),
    );
  }

  /// Builds the horizontal layout for tablet/landscape mode
  Widget _buildHorizontalLayout(BuildContext context) {
    return Row(
      children: [
        // Left side: Warning (1/4)
        Expanded(
          flex: 1,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: PastelAdmonition.caution(
                text: AppLocalizations.of(context)!.qiblaOverheadWarn,
              ),
            ),
          ),
        ),
        // Right side: Compass (3/4)
        const Expanded(flex: 3, child: QiblaCompass()),
      ],
    );
  }

  /// Builds the vertical layout for mobile portrait mode
  Widget _buildVerticalLayout(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: PastelAdmonition.caution(
              text: AppLocalizations.of(context)!.qiblaOverheadWarn),
        ),
        const Expanded(child: QiblaCompass()),
      ],
    );
  }
}
