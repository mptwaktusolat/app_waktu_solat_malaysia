import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  CollectionReference _faqCollection;
  @override
  void initState() {
    super.initState();
    _faqCollection = FirebaseFirestore.instance.collection('faq');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        centerTitle: true,
      ),
      //TODO: Add imageaw
      //https://firebasestorage.googleapidrs.com/v0/b/malaysia-waktu-solat.appspot.com/o/In%20app%2Fundraw_Questions_re_1fy7.png?alt=media&token=2e1ca79e-3e63-4677-8e07-7b3e7b33cae2
      body: StreamBuilder(
        stream: _faqCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data.docs[index]['title']),
                  subtitle: Text(snapshot.data.docs[index]['url']),
                  trailing: FaIcon(
                    FontAwesomeIcons.externalLinkAlt,
                    size: 18,
                  ),
                  onTap: () {
                    LaunchUrl.normalLaunchUrl(
                        url: snapshot.data.docs[index]['url'],
                        useCustomTabs: true);
                  },
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Text(':")'),
            );
          }
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