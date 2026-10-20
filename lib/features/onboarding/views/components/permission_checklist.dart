import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../controllers/onboarding_permissions_controller.dart';

class PermissionChecklist extends StatelessWidget {
  const PermissionChecklist({super.key, required this.controller});

  final OnboardingPermissionsController controller;

  /// Returns true only after the user explicitly accepts incomplete permissions.
  static Future<bool> confirmContinue(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.onboardingPermissionsWarningTitle),
            content: Text(l10n.onboardingPermissionsWarningBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.onboardingPermissionsReview),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.onboardingPermissionsContinue),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final checkedColor = WidgetStateProperty.resolveWith<Color?>((states) {
      return states.contains(WidgetState.selected) ? Theme.of(context).colorScheme.primary : null;
    });
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (controller.busy) const LinearProgressIndicator(),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: controller.locationGranted,
            enabled: !controller.busy,
            fillColor: checkedColor,
            title: Text(l10n.onboardingPermissionsLocation),
            subtitle: Text(l10n.onboardingPermissionsLocationDesc),
            onChanged: controller.busy || controller.locationGranted
                ? null
                : (_) => controller.requestLocation(),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: controller.notificationsGranted,
            enabled: !controller.busy,
            fillColor: checkedColor,
            title: Text(l10n.onboardingPermissionsNotifications),
            subtitle: Text(l10n.onboardingPermissionsNotificationsDesc),
            onChanged: controller.busy || controller.notificationsGranted
                ? null
                : (_) => controller.requestNotifications(),
          ),
          if (controller.supportsExactAlarms)
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: controller.exactAlarmsGranted,
              enabled: !controller.busy,
              fillColor: checkedColor,
              title: Text(l10n.onboardingPermissionsAlarms),
              subtitle: Text(l10n.onboardingPermissionsAlarmsDesc),
              onChanged: controller.busy || controller.exactAlarmsGranted
                  ? null
                  : (_) => controller.requestExactAlarms(),
            ),
          if (controller.autoStartAvailable == true) ...[
            ListTile(
              title: Text(l10n.onboardingPermissionsAutostart),
              subtitle: Text(l10n.onboardingPermissionsAutostartDesc),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton.icon(
                  onPressed: controller.busy ? null : controller.openAutoStart,
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.notifTsOpenSetting),
                ),
              ),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: controller.autoStartAcknowledged,
              title: Text(l10n.onboardingPermissionsMarkDone),
              subtitle: Text(l10n.onboardingPermissionsManualCheck),
              onChanged: controller.busy
                  ? null
                  : (value) => controller.acknowledgeAutoStart(value ?? false),
            ),
          ],
          if (controller.hasError) ...[
            const SizedBox(height: 8),
            Text(l10n.onboardingPermissionsError),
            TextButton.icon(
              onPressed: controller.busy ? null : controller.refresh,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.updatePageTryAgain),
            ),
          ],
        ],
      ),
    );
  }
}
