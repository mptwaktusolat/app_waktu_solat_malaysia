import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _faqItems = [
      FaqItem(
          title: 'Show/Hide Imsak, Syuruk & Dhuha time',
          url: 'https://bit.ly/3mSUZt8'),
      FaqItem(
          title: 'How to fix wrong hijri time',
          url: 'https://bit.ly/mpthijrioffset')
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        centerTitle: true,
      ),
      //TODO: Add image
      //https://firebasestorage.googleapis.com/v0/b/malaysia-waktu-solat.appspot.com/o/In%20app%2Fundraw_Questions_re_1fy7.png?alt=media&token=2e1ca79e-3e63-4677-8e07-7b3e7b33cae2
      body: ListView.builder(
        itemCount: _faqItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_faqItems[index].title),
            subtitle: Text(_faqItems[index].url.substring(8)),
            trailing: FaIcon(
              FontAwesomeIcons.externalLinkAlt,
              size: 18,
            ),
            onTap: () {
              LaunchUrl.normalLaunchUrl(
                  url: _faqItems[index].url, useCustomTabs: true);
            },
          );
        },
      ),
    );
  }
}

class FaqItem {
  String title;

  String url;

  /// Url must have https:// at front
  FaqItem({@required this.title, @required this.url});
}
