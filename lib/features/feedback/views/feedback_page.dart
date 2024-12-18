import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../constants.dart';
import '../../../env.dart';
import '../../../location_utils/location_data.dart';
import '../../../utils/launch_url.dart';
import '../services/feedback_submission_service.dart';

/// This just an app built with express js, that handle
/// the transaction to the Firebase.

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? _deviceInfo;
  Map<String, dynamic>? _appMetadata;
  Map<String, dynamic>? _sensitiveData;
  bool _isSendLoading = false;
  bool _logIsChecked = true;
  bool _isSensitiveChecked = false;

  @override
  void initState() {
    super.initState();

    _sensitiveData = {
      'Recent GPS loc':
          '${LocationData.position?.latitude},${LocationData.position?.longitude}',
    };
  }

  void _submitFeedback() async {
    // Kalau soalan tu ada tanda soalan, prompt user untuk masukkan emel
    // supaya saya dapat reply ke dia nanti. But optional je
    if (_emailController.text.isEmpty &&
        _messageController.text.contains('?')) {
      final res = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content:
                Text(AppLocalizations.of(context)!.feedbackMessageContainQ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child:
                      Text(AppLocalizations.of(context)!.feedbackSendAnyway)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppLocalizations.of(context)!.feedbackAddEmail))
            ],
          );
        },
      );

      // Cancel next operation for user to enter their email
      if (!res) return;
    }

    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      setState(() => _isSendLoading = true);
      try {
        await FeedbackSubmissionService.submitFeedback(
          _messageController.text.trim(),
          email: _emailController.text.trim(),
          otherPayloads: {
            ..._appMetadata!,
            if (_logIsChecked) 'Device info': _deviceInfo,
            if (_isSensitiveChecked) ..._sensitiveData!
          },
        );
        setState(() => _isSendLoading = false);
        Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!.feedbackThanks,
                backgroundColor: Colors.green,
                toastLength: Toast.LENGTH_LONG)
            .then((value) => Navigator.pop(context));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ));
        setState(() => _isSendLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.feedbackTitle),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      validator: (value) => value!.isNotEmpty
                          ? null
                          : AppLocalizations.of(context)!.feedbackFieldEmpty,
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.feedbackWriteHere,
                          border: const OutlineInputBorder()),
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) return null;
                        if (EmailValidator.validate(value)) {
                          return null;
                        }
                        return AppLocalizations.of(context)!
                            .feedbackIncorrectEmail;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText:
                              AppLocalizations.of(context)!.feedbackEmailHere,
                          border: const OutlineInputBorder()),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                    ),
                  ],
                ),
              ),
            ),
            // Send button / butang hantar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ElevatedButton.icon(
                onPressed: _submitFeedback,
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
                    : Text(AppLocalizations.of(context)!.feedbackSend),
              ),
            ),
            FutureBuilder(
              future: DeviceInfoPlugin().androidInfo,
              builder: (_, AsyncSnapshot<AndroidDeviceInfo> snapshot) {
                if (snapshot.hasData) {
                  _deviceInfo = {
                    'Android version': snapshot.data!.version.release,
                    'Android Sdk': snapshot.data!.version.sdkInt,
                    'Device': snapshot.data!.device,
                    'Brand': snapshot.data!.brand,
                    'Model': snapshot.data!.model,
                    'Supported ABIs': snapshot.data!.supportedAbis,
                    'Screen Sizes': MediaQuery.of(context).size.toString(),
                    'Timezone': DateTime.now().timeZoneOffset.toString(),
                    'Device Locale': Platform.localeName,
                  };

                  return CheckboxListTile(
                      secondary: OutlinedButton(
                        child: Text(AppLocalizations.of(context)!
                            .feedbackViewDeviceInfo),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                _DetailedInfoDialog(details: _deviceInfo!),
                          );
                        },
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      subtitle: Text(AppLocalizations.of(context)!
                          .feedbackDeviceInfoRecommended),
                      title: Text(AppLocalizations.of(context)!
                          .feedbackIncludeDeviceInfo),
                      value: _logIsChecked,
                      onChanged: (value) {
                        setState(() => _logIsChecked = value!);
                      });
                } else if (snapshot.hasError) {
                  return Text(
                      AppLocalizations.of(context)!.feedbackTroubleDeviceInfo);
                } else {
                  return ListTile(
                    leading: const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator()),
                    title:
                        Text(AppLocalizations.of(context)!.feedbackGettingInfo),
                  );
                }
              },
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
                if (snapshot.hasData) {
                  _appMetadata = {
                    'App version': snapshot.data!.version,
                    'App build number': snapshot.data!.buildNumber,
                    'Prayer API': GetStorage().read(kStoredApiPrayerCall),
                    'zone': GetStorage().read(kStoredLocationJakimCode),
                    'app locale': AppLocalizations.of(context)!.localeName,
                  };

                  return CheckboxListTile(
                      secondary: OutlinedButton(
                        child: Text(AppLocalizations.of(context)!
                            .feedbackViewDeviceInfo),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                _DetailedInfoDialog(details: _appMetadata!),
                          );
                        },
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      subtitle: Text(
                          AppLocalizations.of(context)!.feedbackAppMetadataSub),
                      title: Text(
                          AppLocalizations.of(context)!.feedbackAppMetadata),
                      value: true,
                      onChanged: null);
                } else if (snapshot.hasError) {
                  return Text(
                      AppLocalizations.of(context)!.feedbackTroubleDeviceInfo);
                } else {
                  return ListTile(
                    leading: const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator()),
                    title:
                        Text(AppLocalizations.of(context)!.feedbackGettingInfo),
                  );
                }
              },
            ),
            CheckboxListTile(
                secondary: OutlinedButton(
                  child: Text(
                      AppLocalizations.of(context)!.feedbackViewDeviceInfo),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          _DetailedInfoDialog(details: _sensitiveData!),
                    );
                  },
                ),
                controlAffinity: ListTileControlAffinity.leading,
                subtitle:
                    Text(AppLocalizations.of(context)!.feedbackSensitiveSub),
                title: Text(AppLocalizations.of(context)!.feedbackSensitive),
                value: _isSensitiveChecked,
                onChanged: (value) {
                  setState(() => _isSensitiveChecked = value!);
                }),
            const Spacer(flex: 3),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(AppLocalizations.of(context)!.feedbackAlsoDo),
                ),
                const Expanded(child: Divider())
              ],
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              icon: const FaIcon(FontAwesomeIcons.circleQuestion, size: 13),
              onPressed: () {
                final faqPageUrl = Uri.parse(envAppSupportWebsite)
                    .resolve('/docs/intro')
                    .toString();
                LaunchUrl.normalLaunchUrl(url: faqPageUrl);
              },
              label: Text(AppLocalizations.of(context)!.feedbackReadFaq),
            ),
            TextButton.icon(
              icon: const FaIcon(FontAwesomeIcons.github, size: 13),
              onPressed: () {
                final githubIssueUrl = '$envGithubRepoLink/issues';
                LaunchUrl.normalLaunchUrl(url: githubIssueUrl);
              },
              label: Text(AppLocalizations.of(context)!.feedbackReportGithub),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _DetailedInfoDialog extends StatelessWidget {
  const _DetailedInfoDialog({required this.details});

  final Map<String, dynamic> details;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: ListView.builder(
      shrinkWrap: true,
      itemCount: details.length + 1,
      itemBuilder: (_, index) {
        if (index < details.length) {
          final key = details.keys.elementAt(index);
          return ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(key)],
            ),
            title: Text(details[key].toString()),
          );
        } else {
          return TextButton.icon(
              icon: const FaIcon(FontAwesomeIcons.copy, size: 12),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: details.toString())).then(
                    (value) => Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!
                            .feedbackDeviceInfoCopy));
              },
              label: Text(
                  AppLocalizations.of(context)!.feedbackDeviceInfoCopyAll));
        }
      },
    ));
  }
}
