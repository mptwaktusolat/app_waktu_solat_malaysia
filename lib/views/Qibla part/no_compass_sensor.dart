import 'package:flutter/material.dart';

class NoCompassSensor extends StatelessWidget {
  const NoCompassSensor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_off_outlined,
            size: 120,
            color: Colors.redAccent,
          ),
          Text(
            'Sorry. No compass sensor is available in this device.',
            textAlign: TextAlign.center,
          ),
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back'))
        ],
      ),
    );
  }
}
