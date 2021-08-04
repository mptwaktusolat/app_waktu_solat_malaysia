import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info/package_info.dart';
import '../CONSTANTS.dart' as constants;
import '../CONSTANTS.dart';
import '../locationUtil/LocationData.dart';
import '../utils/launchUrl.dart';
import 'faq.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key key}) : super(key: key);
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference _reportsCollection;
  Map<String, dynamic> _deviceInfo;
  PackageInfo packageInfo;
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
          title: const Text('Feedback'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                        validator: (value) =>
                            value.isNotEmpty ? null : 'Field can\'t be empty',
                        controller: _messageController,
                        decoration: const InputDecoration(
                            hintText: 'Please leave your feedback/report here',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 4),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) => value.isNotEmpty
                          ? EmailValidator.validate(value)
                              ? null
                              : 'Incorrect email format'
                          : null,
                      controller: _emailController,
                      decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'Your email address (optional)',
                          border: OutlineInputBorder()),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
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
                        child: const Text('View...'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                  child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _deviceInfo.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < _deviceInfo.length) {
                                    var key = _deviceInfo.keys.elementAt(index);
                                    return ListTile(
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [Text(key)],
                                      ),
                                      title: Text(_deviceInfo[key].toString()),
                                    );
                                  } else {
                                    return TextButton.icon(
                                        icon: const FaIcon(
                                            FontAwesomeIcons.copy,
                                            size: 12),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: _deviceInfo.toString()))
                                              .then((value) =>
                                                  Fluttertoast.showToast(
                                                      msg: 'Copied'));
                                        },
                                        label: const Text('Copy all'));
                                  }
                                },
                              ));
                            },
                          );
                        },
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      subtitle: const Text('(Recommended)'),
                      title: const Text(
                        'Include device info',
                      ),
                      value: _logIsChecked,
                      onChanged: (value) {
                        setState(() {
                          _logIsChecked = value;
                        });
                      });
                } else if (snapshot.hasError) {
                  return const Text('Trouble getting device info');
                } else {
                  return const ListTile(
                    leading: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator()),
                    title: Text('Getting device info...'),
                  );
                }
              },
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  if (_emailController.text.isEmpty &&
                      _messageController.text.contains('?')) {
                    var res = await showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content: const Text(
                                'Looks like your message contain question(s). Provide your email so we can get back to you.\n\nWould you like to add your email?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Send without email')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Add email'))
                            ],
                          );
                        });

                    // Cancel next operation for user to enter their email
                    if (!res) {
                      return;
                    }
                  }

                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).unfocus();
                    setState(() => _isSendLoading = true);
                    try {
                      await _reportsCollection.add({
                        'Date creation': FieldValue.serverTimestamp(),
                        'User email': _emailController.text.trim(),
                        'User message': _messageController.text.trim(),
                        'App version': packageInfo.version,
                        'App build number': packageInfo.buildNumber,
                        'Prayer API called':
                            GetStorage().read(kStoredApiPrayerCall) ??
                                'no pray api called',
                        'Position': (LocationData.position != null)
                            ? GeoPoint(LocationData.position.latitude,
                                LocationData.position.longitude)
                            : 'no detect',
                        'Locality':
                            GetStorage().read(kStoredLocationLocality) ??
                                'no locality called',
                        'Device info': _logIsChecked ? _deviceInfo : null,
                        'Hijri Offset':
                            GetStorage().read(constants.kHijriOffset),
                      });
                      setState(() => _isSendLoading = false);
                      Fluttertoast.showToast(
                              msg: 'Thank you for your valuable feedback.',
                              backgroundColor: Colors.green,
                              toastLength: Toast.LENGTH_LONG)
                          .then((value) => Navigator.pop(context));
                    } on FirebaseException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error: ${e.message}'),
                        backgroundColor: Colors.red,
                      ));
                      setState(() => _isSendLoading = false);
                    }
                  }
                },
                icon: !_isSendLoading
                    ? const FaIcon(FontAwesomeIcons.paperPlane, size: 13)
                    : const SizedBox.shrink(),
                label: _isSendLoading
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                    : const Text('Send')),
            const Spacer(flex: 3),
            Row(
              children: const [
                Expanded(child: Divider()),
                Text('OR'),
                Expanded(child: Divider())
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.questionCircle, size: 13),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FaqPage()));
              },
              label: const Text('Read Frequently Asked Questions (FAQ)'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              icon: const FaIcon(FontAwesomeIcons.github, size: 13),
              onPressed: () {
                LaunchUrl.normalLaunchUrl(
                    url: constants.kGithubRepoLink + '/issues');
              },
              label: const Text('Report / Follow issues on GitHub'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
