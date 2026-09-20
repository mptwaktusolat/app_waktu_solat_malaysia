import 'package:flutter/material.dart';

class LocationErrorWidget extends StatelessWidget {
  const LocationErrorWidget({
    super.key,
    required this.error,
    required this.actionLabel,
    required this.onPressed,
  });

  final String error;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const box = SizedBox(height: 32);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.location_off,
            size: 130,
            color: Colors.redAccent,
          ),
          box,
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          box,
          ElevatedButton(
            onPressed: onPressed,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
