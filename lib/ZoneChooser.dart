import 'package:flutter/material.dart';

//TODO: Make sure this things works

class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  List list1 = ['Option Item A', 'Option Item B', 'Option Item C'];
  String selection = 'None';

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _openshowModalBottomSheet,
      child: Text(
        'showModalBottomSheet: $selection',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Future _openshowModalBottomSheet() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: ListView(
              children: List.generate(3, (index) {
                return ListTile(
                  title: Text(list1[index]),
                  onTap: () {
                    Navigator.pop(context, list1[index]);
                  },
                );
              }),
            ),
          );
        });
    setState(() {
      selection = option;
    });
  }
}
