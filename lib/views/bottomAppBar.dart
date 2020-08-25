import 'package:flutter/material.dart';

class MyBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 18.0,
      shape: CircularNotchedRectangle(),
      color: Colors.teal[50],
      child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            children: [
              IconButton(
                  tooltip: 'Open menu',
                  icon: Icon(Icons.menu),
                  onPressed: null),
              IconButton(
                  tooltip: 'Favourite',
                  icon: Icon(Icons.favorite),
                  onPressed: null),
            ],
          )),
    );
  }
}
