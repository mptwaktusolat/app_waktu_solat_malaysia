import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_widget/home_widget.dart';

class WidgetDataPage extends StatelessWidget {
  const WidgetDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Widget Data'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FutureBuilder(
              future: HomeWidget.getWidgetData('last_updated'),
              builder: (context, snapshot) {
                return _WidgetDataItem(
                  title: 'last_updated',
                  data: snapshot.data.toString(),
                );
              }),
          FutureBuilder(
              future: HomeWidget.getWidgetData('widget_title'),
              builder: (context, snapshot) {
                return _WidgetDataItem(
                  title: 'widget_title',
                  data: snapshot.data.toString(),
                );
              }),
          FutureBuilder(
              future: HomeWidget.getWidgetData('prayer_data'),
              builder: (context, snapshot) {
                return _WidgetDataItem(
                  title: 'prayer_data',
                  data: snapshot.data.toString(),
                );
              }),
        ],
      ),
    );
  }
}

class _WidgetDataItem extends StatelessWidget {
  const _WidgetDataItem({required this.title, required this.data});

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: data));
        Fluttertoast.showToast(msg: 'Copied $title');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.start,
          ),
          Text(data),
        ],
      ),
    );
  }
}
