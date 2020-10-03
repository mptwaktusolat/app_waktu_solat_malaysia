import 'package:flutter/material.dart';

class ContributionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contribution and Support'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Hello workd'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
