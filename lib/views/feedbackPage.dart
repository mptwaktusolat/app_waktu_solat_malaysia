import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info/package_info.dart';
import '../CONSTANTS.dart' as Constants;
import '../CONSTANTS.dart';
import '../utils/AppInformation.dart';
import '../utils/launchUrl.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  AppInfo appInfo = AppInfo();
  double selectedOutlineWidth = 4.0;
  double unselectedOutlineWidth = 1.0;
  String hintTextForFeedback = 'Please leave your feedback here';
  TextEditingController messageController = TextEditingController();
  CollectionReference reportsCollection;
  Map<String, dynamic> _deviceInfo;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    reportsCollection = FirebaseFirestore.instance.collection('reports');
  }

  String prayApiCalled =
      GetStorage().read(kStoredApiPrayerCall) ?? 'no pray api called';
  String localityCalled =
      GetStorage().read(kStoredLocationLocality) ?? 'no locality called';

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
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Any suggestion or bug report',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: TextFormField(
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Field can\'t be empty',
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: hintTextForFeedback,
                        border: OutlineInputBorder()),
                    // textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    maxLines: 4),
              ),
            ),
            Container(
              child: FutureBuilder(
                future: DeviceInfoPlugin().androidInfo,
                builder: (context, AsyncSnapshot<AndroidDeviceInfo> snapshot) {
                  if (snapshot.hasData) {
                    _deviceInfo = {
                      'Android version': snapshot.data.version.release,
                      'Android Sdk': snapshot.data.version.sdkInt,
                      'Device': snapshot.data.device,
                      'Brand': snapshot.data.brand,
                      'Model': snapshot.data.model,
                      'Supported ABIs': snapshot.data.supportedAbis,
                      'Screen Sizes': MediaQuery.of(context).size
                    };

                    return CheckboxListTile(
                        secondary: OutlinedButton(
                          child: Text('View data collected...'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _deviceInfo.length + 1,
                                  itemBuilder: (context, index) {
                                    print(_deviceInfo.length);
                                    if (index < _deviceInfo.length) {
                                      var key =
                                          _deviceInfo.keys.elementAt(index);
                                      return ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [Text(key)],
                                        ),
                                        title:
                                            Text(_deviceInfo[key].toString()),
                                      );
                                    } else {
                                      return TextButton.icon(
                                          icon: FaIcon(FontAwesomeIcons.copy,
                                              size: 12),
                                          onPressed: () {},
                                          label: Text('Copy all'));
                                    }
                                  },
                                ));
                              },
                            );
                          },
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        subtitle: Text('(Recommended)'),
                        title: Text(
                          'Include device info',
                        ),
                        value: _logIsChecked,
                        onChanged: (value) {
                          setState(() {
                            _logIsChecked = value;
                          });
                        });
                  } else if (snapshot.hasError) {
                    return Text('Trouble getting device info');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Getting device info...'),
                    );
                  } else {
                    return Text('Device info');
                  }
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print('Sending report');
                    reportsCollection.add({
                      'Date creation': FieldValue.serverTimestamp(),
                      'App version': PackageInfo().version,
                      'App build number': PackageInfo().buildNumber,
                      'Prayer API called': prayApiCalled,
                      'Locality': localityCalled,
                      'Device info': _logIsChecked ? _deviceInfo : null,
                    });
                  }
                },
                child: Text('Send report now')),
            Spacer(flex: 3),
            Row(
              children: [
                Expanded(child: Divider()),
                Text('OR'),
                Expanded(child: Divider())
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                icon: FaIcon(FontAwesomeIcons.github),
                onPressed: () {
                  LaunchUrl.normalLaunchUrl(
                      url: Constants.kGithubRepoLink + '/issues');
                },
                label: Text('Report / Follow issues on GitHub'),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
