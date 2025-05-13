import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart'
    as custom_tabs_lite;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class LaunchUrl {
  LaunchUrl._();

  /// Launch URL Default
  static void normalLaunchUrl({required String url}) async {
    log('Launching URL: $url');

    try {
      await url_launcher.launchUrl(
        Uri.parse(url),
        mode: url_launcher.LaunchMode.externalApplication,
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              'Could not launch URL. Error $e.\nPlease send feedback to developer.',
          backgroundColor: Colors.red);
    }
  }

  /// Launch URL in custom tab.
  static void launchInCustomTab({required String url}) async {
    log('Launching URL in custom tabs: $url');
    try {
      await custom_tabs_lite.launchUrl(Uri.parse(url),
          options: custom_tabs_lite.LaunchOptions(
            barColor: Colors.teal,
            onBarColor: Colors.teal.shade200,
            barFixingEnabled: false,
          ));
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              'Could not launch URL in custom tabs. Error $e.\nPlease send feedback to developer.',
          backgroundColor: Colors.red);
    }
  }

  /// Launch URL in a partial custom tab.
  /// See also:
  /// https://pub.dev/packages/flutter_custom_tabs#partial-display
  /// https://developer.chrome.com/docs/android/custom-tabs/guide-partial-custom-tabs
  static void launchInSheetView(
      {required BuildContext context, required String url}) async {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    log('Launching URL in partial custom tabs: $url');
    await launchUrl(
      Uri.parse(url),
      customTabsOptions: CustomTabsOptions.partial(
        configuration: PartialCustomTabsConfiguration.adaptiveSheet(
          initialHeight: mediaQuery.size.height * 0.7,
          initialWidth: mediaQuery.size.width * 0.4,
          activitySideSheetMaximizationEnabled: true,
          activitySideSheetDecorationType:
              CustomTabsActivitySideSheetDecorationType.shadow,
          activitySideSheetRoundedCornersPosition:
              CustomTabsActivitySideSheetRoundedCornersPosition.top,
          cornerRadius: 16,
        ),
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
        ),
      ),
      safariVCOptions: SafariViewControllerOptions.pageSheet(
        configuration: const SheetPresentationControllerConfiguration(
          detents: {
            SheetPresentationControllerDetent.large,
            SheetPresentationControllerDetent.medium,
          },
          prefersScrollingExpandsWhenScrolledToEdge: true,
          prefersGrabberVisible: true,
          prefersEdgeAttachedInCompactHeight: true,
        ),
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }
}
