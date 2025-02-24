import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';

import '../../../shared/utils/screenshot_widget.dart';
import 'templates/share_card_1.dart';
import 'templates/share_card_2.dart';

class ShareImagePreviewPage extends StatefulWidget {
  const ShareImagePreviewPage({super.key});

  @override
  State<ShareImagePreviewPage> createState() => _ShareImagePreviewPageState();
}

class _ShareImagePreviewPageState extends State<ShareImagePreviewPage> {
  late GlobalKey selectedScreenshotKey;
  // GlobalKey selectedWidgetKey;

  final shareCards = [
    ShareCard1(),
    ShareCard2(),
  ];

  List<GlobalKey> shareCardWidgetKeys = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < shareCards.length; i++) {
      shareCardWidgetKeys.add(GlobalKey());
    }

    selectedScreenshotKey = shareCardWidgetKeys[0];
  }

  @override
  Widget build(BuildContext context) {
    print('screenshotKey: $selectedScreenshotKey');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Preview'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
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
          ),
          Gap(25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final imageBytes = await ScreenshotWidget.takeScreenshot(
                      selectedScreenshotKey);

                  if (imageBytes == null) {
                    print('Failed to capture screenshot.');
                    return;
                  }

                  final tempFileName = 'screenshot-${DateTime.now()}.jpg';

                  final xFile = XFile.fromData(imageBytes,
                      name: tempFileName, mimeType: 'image/jpeg');

                  Share.shareXFiles(
                    [xFile],
                    text: 'Check out this prayer time card!',
                  );
                },
                label: Text('Share'),
                icon: Icon(Icons.adaptive.share),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardWrapper extends StatelessWidget {
  const _CardWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
