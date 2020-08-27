import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class MyBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 18.0,
      shape: CircularNotchedRectangle(),
      color: Colors.teal[50],
      child: Row(
        children: [
          IconButton(
              tooltip: 'Open menu',
              icon: Icon(Icons.menu),
              color: Colors.grey,
              onPressed: () {
                menuModalBottomSheet(context);
              }),
          //TODO: Copy, setting buton
        ],
      ),
    );
  }
}

Future<String> getPackageInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  return version;
}

void menuModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(8.0),
          child: Wrap(children: <Widget>[
            ListTile(
              title: Text('Rate app'),
              leading: Icon(Icons.star),
              onTap: () {
                print('Hello');
              },
            ),
            ListTile(
              title: Text('Send feedback'),
              leading: Icon(Icons.feedback),
              onTap: () {
                print('Hello');
              },
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text('About app'),
              subtitle: FutureBuilder(
                future: getPackageInfo(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) =>
                        Text(
                  snapshot.hasData ? snapshot.data : "Loading ...",
                  style: TextStyle(color: Colors.black38),
                ),
              ),
              leading: Icon(Icons.info_outline),
              onTap: () {
                print('Hello');
              },
            ),
          ]),
        );
      });

//TODO: Add icon, add about dialog, rate Google PLay dialog
}
