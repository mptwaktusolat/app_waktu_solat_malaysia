import 'package:flutter/material.dart';

/// Widget to show Jakim code
class LocationBubbleWidget extends StatelessWidget {
  const LocationBubbleWidget(this.shortCode,
      {this.isSelected = false, super.key});

  /// The Jakim Code. Example: "SGR03"
  final String shortCode;

  /// Whether this bubble should show as selected
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.primaryContainer,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        shortCode,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
