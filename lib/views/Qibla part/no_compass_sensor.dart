import 'package:flutter/material.dart';

class NoCompassSensor extends StatelessWidget {
  const NoCompassSensor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = SizedBox(height: 32);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_off_outlined,
            size: 130,
            color: Colors.redAccent,
          ),
          box,
          Text(
            'Sorry. No compass sensor is available in this device.',
            textAlign: TextAlign.center,
          ),
          box,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).buttonColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Go back',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
