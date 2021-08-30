import 'package:flutter/material.dart';

class NoCompassSensor extends StatelessWidget {
  const NoCompassSensor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const box = SizedBox(height: 32);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.explore_off_outlined,
            size: 130,
            color: Colors.redAccent,
          ),
          box,
          const Text(
            'Sorry. No compass sensor is available in this device.',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          box,
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Go back',
            ),
          )
        ],
      ),
    );
  }
}
