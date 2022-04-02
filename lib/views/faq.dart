import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/launchUrl.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  late CollectionReference _faqCollection;
  @override
  void initState() {
    super.initState();
    _faqCollection = FirebaseFirestore.instance.collection('faq');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _faqCollection.get(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data!.docs[index]['title']),
                  subtitle: Text(
                    snapshot.data!.docs[index]['url'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.upRightFromSquare,
                    size: 18,
                  ),
                  onTap: () {
                    LaunchUrl.normalLaunchUrl(
                        url: snapshot.data!.docs[index]['url'],
                        useCustomTabs: true);
                  },
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SpinKitCubeGrid(
              color: Colors.teal,
            ));
          } else {
            return const Center(
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
  FaqItem({required this.title, required this.url});
}
