import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScreenshotWidget {
  /// Takes a screenshot of the widget associated with the given [key].
  ///
  /// This function captures the widget as an image and returns it as a [Uint8List].
  ///
  /// Example usage:
  /// ```dart
  /// GlobalKey screenshotKey = GlobalKey();
  ///
  /// // Widget to be captured
  /// Widget myWidget = RepaintBoundary(
  ///   key: screenshotKey,
  ///   child: MyCustomWidget(),
  /// );
  ///
  /// // Capture the screenshot
  /// Uint8List? imageBytes = await takeScreenshot(screenshotKey);
  ///
  /// // Do something with the captured image
  /// if (imageBytes != null) {
  ///   // Save or display the image
  /// }
  /// ```
  ///
  /// Returns a [Uint8List] containing the image data, or `null` if the screenshot could not be taken.
  static Future<Uint8List?> takeScreenshot(GlobalKey key) async {
    try {
      final RenderRepaintBoundary boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;
      if (kDebugMode && boundary.debugNeedsPaint) {
        print("Waiting for boundary to be painted.");
        await Future.delayed(const Duration(milliseconds: 20));
      }
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
}
