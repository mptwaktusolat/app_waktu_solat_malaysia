import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/locale_provider.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/utils/screenshot_widget.dart';
import 'templates/share_card_1.dart';
import 'templates/share_card_2.dart';

/// A page that displays preview of different prayer time card templates.
///
/// Allows users to select a card design and share it as an image.
class ShareImagePreviewPage extends StatefulWidget {
  /// Creates a new instance of [ShareImagePreviewPage].
  const ShareImagePreviewPage({super.key});

  @override
  State<ShareImagePreviewPage> createState() => _ShareImagePreviewPageState();
}

class _ShareImagePreviewPageState extends State<ShareImagePreviewPage> {
  /// Key of the currently selected card for screenshot capture.
  late GlobalKey selectedScreenshotKey;

  /// Available sharing card templates.
  final List<Widget> shareCards = [
    ShareCard1(),
    ShareCard2(),
  ];

  /// List of keys for each share card to enable screenshots.
  final List<GlobalKey> shareCardWidgetKeys = [];

  @override
  void initState() {
    super.initState();

    // Create a GlobalKey for each share card
    for (var i = 0; i < shareCards.length; i++) {
      shareCardWidgetKeys.add(GlobalKey());
    }

    // Set the initial selected key to the first card
    selectedScreenshotKey = shareCardWidgetKeys[0];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(localizations.shareImage),
        elevation: 0,
        actions: [
          // show toggle only when debugging
          if (kDebugMode || GetStorage().read(kDiscoveredDeveloperOption))
            _buildLocaleToggle(context),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.primaryContainer.withValues(alpha: 0.7),
              colorScheme.primaryContainer.withValues(alpha: 0.3),
              colorScheme.primaryContainer.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Card preview carousel
            _buildCardCarousel(),

            const Gap(25),

            // Share button
            _buildShareButton(context),
          ],
        ),
      ),
    );
  }

  /// Builds the locale toggle button for switching between English and Malay.
  Widget _buildLocaleToggle(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        final isMs = localeProvider.appLocale == 'ms';
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
          onPressed: () {
            localeProvider.appLocale = isMs ? 'en' : 'ms';
          },
          child: Text(isMs ? 'EN' : 'MS'),
        );
      },
    );
  }

  /// Builds the card carousel that allows users to swipe between different card designs.
  Widget _buildCardCarousel() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 410,
      ),
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        itemCount: shareCards.length,
        onPageChanged: (value) {
          setState(() {
            selectedScreenshotKey = shareCardWidgetKeys[value];
          });
        },
        itemBuilder: (context, index) => _CardWrapper(
          child: RepaintBoundary(
            key: shareCardWidgetKeys[index],
            child: shareCards[index],
          ),
        ),
      ),
    );
  }

  /// Builds the share button that captures and shares the selected card.
  Widget _buildShareButton(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ElevatedButton.icon(
      onPressed: () => _shareSelectedCard(context),
      label: Text(localizations.genericShare),
      icon: Icon(Icons.adaptive.share),
    );
  }

  /// Captures and shares the currently selected card.
  Future<void> _shareSelectedCard(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    // Capture the selected card as an image
    final imageBytes =
        await ScreenshotWidget.takeScreenshot(selectedScreenshotKey);

    if (imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.shareImageFailed)),
      );
      return;
    }

    final tempFileName =
        'prayer-time-${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Create an XFile from the image data
    final xFile =
        XFile.fromData(imageBytes, name: tempFileName, mimeType: 'image/jpeg');

    final todayFormatttedDate =
        DateFormat('dd/MM/yyyy', localizations.localeName)
            .format(DateTime.now());

    // Share the image
    await SharePlus.instance.share(ShareParams(
      files: [xFile],
      text: localizations.shareSubject(todayFormatttedDate),
    ));
  }
}

/// A wrapper widget that applies styling to card previews.
class _CardWrapper extends StatelessWidget {
  /// Creates a new [_CardWrapper] instance.
  const _CardWrapper({required this.child});

  /// The card content to be wrapped.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
