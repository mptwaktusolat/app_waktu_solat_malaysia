import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../CONSTANTS.dart' as Constants;
import '../CONSTANTS.dart';
import '../utils/launchUrl.dart';

enum FeedbackCategory { suggestion, bug, compliment }

class FeedbackToEmail {
  String _message;
  String _debugLog;

  void messageSetter(String message) {
    this._message = message;
  }

  void debugLogSetter(String debugLog) {
    this._debugLog = debugLog;
  }

  void clearDebugLog() {
    this._debugLog = '';
  }

  String getAllData() {
    String data = '''

    Message: $_message, 

    <---------Debug log:---------------

    $_debugLog
    
    ------------------EO🐛---------------->
    
    Thank you for submitting feedback. 
    ''';
    //add github issue link

    //EOF is end of feedback
    print(data);
    return data;
  }
}

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  FeedbackCategory feedbackCategory;
  double selectedOutlineWidth = 4.0;
  double unselectedOutlineWidth = 1.0;
  String hintTextForFeedback = 'Please leave your feedback here';
  FeedbackToEmail feedbackToEmail = FeedbackToEmail();
  TextEditingController messageController = TextEditingController();

  var prayApiCalled = GetStorage().read(kStoredApiPrayerCall) ?? 'no calls';
  var locApiCalled = GetStorage().read(kStoredLocationLocality) ?? 'no calls';

  @override
  void initState() {
    super.initState();
  }

  bool _logIsChecked = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Feedback'),
          centerTitle: true,
          actions: [
            IconButton(
                tooltip: 'Send via email',
                icon: Icon(Icons.send),
                onPressed: () {
                  print('Pressed send');
                  if (_logIsChecked) {
                    feedbackToEmail.debugLogSetter('''
                        ----------------------APP--------------------------
                         -- 
                        ---------------------DEVICE---------------------
                        isWeb? $kIsWeb 
                        Screen size ${MediaQuery.of(context).size.toString().substring(4)} DiP
                        PixRatio ${MediaQuery.of(context).devicePixelRatio}

                        Last prayer api called: $prayApiCalled ,
                        Location get: $locApiCalled ,
                    
                      ''');
                  }
                  feedbackToEmail.messageSetter(messageController.text);
                  feedbackToEmail.getAllData();
                  Navigator.pop(context);
                  LaunchUrl.sendViaEmail(feedbackToEmail.getAllData());
                  FocusScope.of(context).unfocus();
                })
          ],
        ),
        body: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Any suggestion or bug report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: hintTextForFeedback,
                  border: OutlineInputBorder(),
                ),
                // textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 4,
              ),
            ),
            Container(
              child: CheckboxListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'Include debug info (Recommended)',
                  ),
                  value: _logIsChecked,
                  onChanged: (value) {
                    setState(() {
                      _logIsChecked = value;
                      feedbackToEmail.clearDebugLog();
                    });
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    LaunchUrl.normalLaunchUrl(
                        url: Constants.kGithubRepoLink + '/issues');
                  },
                  child: Text('Report / Follow issues on GitHub',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
