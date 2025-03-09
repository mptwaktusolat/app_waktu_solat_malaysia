import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.shareImage),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card preview carousel
          _buildCardCarousel(),

          const Gap(25),

          // Share button
          _buildShareButton(context),
        ],
      ),
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

    // Share the image
    await Share.shareXFiles(
      [xFile],
      text: localizations.shareSubject,
    );
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
