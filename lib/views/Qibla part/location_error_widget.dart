import 'package:flutter/material.dart';

class LocationErrorWidget extends StatelessWidget {
  final String error;
  final Function callback;

  const LocationErrorWidget({Key key, this.error, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = SizedBox(height: 32);

    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.location_off,
              size: 130,
              color: Colors.redAccent,
            ),
            box,
            Text(
              error,
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            box,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).buttonColor,
              ),
              child: Text("Retry"),
              onPressed: () {
                if (callback != null) callback();
              },
            ),
          ],
        ),
      ),
    );
  }
}
