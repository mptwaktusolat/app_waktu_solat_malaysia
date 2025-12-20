import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Displays a bottom dialog with customizable title, subtitle, icon, and actions. Call
/// using showModalBottomSheet().
class MptBottomDialog extends StatelessWidget {
  const MptBottomDialog({
    super.key,
    required this.title,
    this.content,
    this.actions,
    this.icon,
    this.iconBackgroundColor,
    this.iconColor,
  });

  /// Danger variant with danger theme colors.
  const MptBottomDialog.danger({
    super.key,
    required this.title,
    this.content,
    this.actions,
    this.icon,
  })  : iconBackgroundColor = const Color(0xFFFFCDD2), // Colors.red.shade100
        iconColor = const Color(0xFFC62828); // Colors.red.shade800

  /// The title of the dialog.
  final String title;

  /// The icon of the dialog.
  final Widget? icon;

  /// The background color of the icon widget.
  final Color? iconBackgroundColor;

  /// The color of the icon.
  final Color? iconColor;

  /// The actions widget of the dialog.
  final Widget? actions;

  /// The content widget of the dialog.
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultIconBackgroundColor =
        iconBackgroundColor ?? theme.colorScheme.primaryContainer;
    final defaultIconColor = iconColor ?? theme.colorScheme.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (icon != null)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: defaultIconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: IconTheme(
                  data: IconThemeData(color: defaultIconColor, size: 42),
                  child: icon!,
                ),
              ),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            if (content != null) content!,
            if (actions != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: actions,
              )
          ],
        ),
      ),
    );
  }
}
