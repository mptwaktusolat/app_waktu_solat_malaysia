import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:waktusolatmalaysia/views/faq.dart';
import '../CONSTANTS.dart' as Constants;
import '../CONSTANTS.dart';
import '../utils/launchUrl.dart';
import 'package:email_validator/email_validator.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _messageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  CollectionReference _reportsCollection;
  Map<String, dynamic> _deviceInfo;
  PackageInfo packageInfo;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSendLoading = false;

  @override
  void initState() {
    super.initState();
    _reportsCollection = FirebaseFirestore.instance.collection('reports');
    getPackageInfo();
  }

  void getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Feedback'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                        validator: (value) =>
                            value.isNotEmpty ? null : 'Field can\'t be empty',
                        controller: _messageController,
                        decoration: InputDecoration(
                            hintText: 'Please leave your feedback/report here',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 4),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (value) => value.isNotEmpty
                          ? EmailValidator.validate(value)
                              ? null
                              : 'Incorrect email format'
                          : null,
                      controller: _emailController,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Your email address (optional)',
                          helperText: 'We may reach you if needed',
                          border: OutlineInputBorder()),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
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
                      'Screen Sizes': MediaQuery.of(context).size.toString()
                    };

                    return CheckboxListTile(
                        secondary: OutlinedButton(
                          child: Text('View...'),
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
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                    text:
                                                        _deviceInfo.toString()))
                                                .then((value) =>
                                                    Fluttertoast.showToast(
                                                        msg: 'Copied'));
                                          },
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
                  } else {
                    return ListTile(
                      leading: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator()),
                      title: Text('Getting device info...'),
                    );
                  }
                },
              ),
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).unfocus();
                    setState(() => _isSendLoading = true);
                    print('Sending report...');
                    try {
                      await _reportsCollection.add({
                        'Date creation': FieldValue.serverTimestamp(),
                        'User email': _emailController.text.trim(),
                        'User message': _messageController.text.trim(),
                        'App version': packageInfo.version,
                        'App build number': packageInfo.buildNumber,
                        'Prayer API called': prayApiCalled,
                        'Locality': localityCalled,
                        'Device info': _logIsChecked ? _deviceInfo : null,
                      });
                      setState(() => _isSendLoading = false);
                      Fluttertoast.showToast(
                              msg: _emailController.text.isEmpty
                                  ? 'Thank you for your valuable feedback.'
                                  : 'Thank you for your valuable feedback. A copy of your response will be sent to your email',
                              backgroundColor: Colors.green,
                              toastLength: Toast.LENGTH_LONG)
                          .then((value) => Navigator.pop(context));
                    } on FirebaseException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error: ${e.message}'),
                        backgroundColor: Colors.red,
                      ));
                      setState(() => _isSendLoading = false);
                    } catch (e) {
                      print('Err: $e');
                    }
                  }
                },
                icon: FaIcon(FontAwesomeIcons.paperPlane, size: 13),
                label: _isSendLoading
                    ? SpinKitRotatingCircle(size: 12, color: Colors.white)
                    : Text('Send')),
            Spacer(flex: 3),
            Row(
              children: [
                Expanded(child: Divider()),
                Text('OR'),
                Expanded(child: Divider())
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: FaIcon(FontAwesomeIcons.questionCircle, size: 13),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => FaqPage()));
              },
              label: Text('Read Frequently Asked Questions (FAQ)'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              icon: FaIcon(FontAwesomeIcons.github, size: 13),
              onPressed: () {
                LaunchUrl.normalLaunchUrl(
                    url: Constants.kGithubRepoLink + '/issues');
              },
              label: Text('Report / Follow issues on GitHub'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
