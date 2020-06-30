import 'package:flutter/material.dart';
import 'package:waktusolatmalaysia/sizeconfig.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malaysia Prayer Time',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan.shade900,
          title: Text('Malaysia Prayer Time'),
          elevation: 0.0,
        ),
        body: AppBody(),
      ),
    );
  }
}

class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight / 5,
            decoration: BoxDecoration(
              color: Colors.cyan.shade900,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
            ),
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  '45:71 am\nPahang',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                )
              ],
            ),
          ),
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print('Pressed');
              },
              child: Container(
                width: 300,
                height: 100,
                child: Text('Card item'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
