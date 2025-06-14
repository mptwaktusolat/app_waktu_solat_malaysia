import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../env.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/launch_url.dart';
import '../viewmodels/feedback_view_model.dart';

/// FeedbackPage is a widget that allows users to submit feedback.
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late FeedbackViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FeedbackViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadDeviceInfo(context);
      _viewModel.loadAppMetadata(
          context, AppLocalizations.of(context)!.localeName);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    // Kalau soalan tu ada tanda soalan, prompt user untuk masukkan emel
    // supaya saya dapat reply ke dia nanti. But optional je
    if (_viewModel.isEmailEmpty() && _viewModel.hasQuestionMark()) {
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

    FocusScope.of(context).unfocus();

    final success = await _viewModel.validateAndSubmitFeedback(context);

    if (success) {
      Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.feedbackThanks,
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG)
          .then((value) => Navigator.pop(context));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error submitting feedback'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
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
                      key: _viewModel.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            validator: (value) => value!.isNotEmpty
                                ? null
                                : AppLocalizations.of(context)!
                                    .feedbackFieldEmpty,
                            controller: _viewModel.messageController,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .feedbackWriteHere,
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
                            controller: _viewModel.emailController,
                            decoration: InputDecoration(
                                isDense: true,
                                hintText: AppLocalizations.of(context)!
                                    .feedbackEmailHere,
                                border: const OutlineInputBorder()),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildDeviceInfoTile(),
                  _buildAppMetadataTile(),
                  _buildSensitiveDataTile(),
                  Gap(24),
                  // Send button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size.fromHeight(50),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed:
                          !_viewModel.isSendLoading ? _submitFeedback : null,
                      icon: !_viewModel.isSendLoading
                          ? const FaIcon(FontAwesomeIcons.paperPlane, size: 14)
                          : null,
                      label: _viewModel.isSendLoading
                          ? SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator())
                          : Text(AppLocalizations.of(context)!.feedbackSend),
                    ),
                  ),
                  const Spacer(flex: 3),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child:
                            Text(AppLocalizations.of(context)!.feedbackAlsoDo),
                      ),
                      const Expanded(child: Divider())
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    icon:
                        const FaIcon(FontAwesomeIcons.circleQuestion, size: 13),
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
                    label: Text(
                        AppLocalizations.of(context)!.feedbackReportGithub),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildDeviceInfoTile() {
    if (_viewModel.deviceInfo == null) {
      return ListTile(
        leading: const SizedBox(
            height: 15, width: 15, child: CircularProgressIndicator()),
        title: Text(AppLocalizations.of(context)!.feedbackGettingInfo),
      );
    }

    return CheckboxListTile(
      secondary: TextButton(
        child: Text(AppLocalizations.of(context)!.feedbackViewDeviceInfo),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) =>
                _DetailedInfoDialog(details: _viewModel.deviceInfo!),
          );
        },
      ),
      controlAffinity: ListTileControlAffinity.leading,
      subtitle:
          Text(AppLocalizations.of(context)!.feedbackDeviceInfoRecommended),
      title: Text(AppLocalizations.of(context)!.feedbackIncludeDeviceInfo),
      value: _viewModel.logIsChecked,
      onChanged: (value) => _viewModel.toggleLogChecked(value!),
    );
  }

  Widget _buildAppMetadataTile() {
    if (_viewModel.appMetadata == null) {
      return ListTile(
        leading: const SizedBox(
            height: 15, width: 15, child: CircularProgressIndicator()),
        title: Text(AppLocalizations.of(context)!.feedbackGettingInfo),
      );
    }

    return CheckboxListTile(
      secondary: TextButton(
        child: Text(AppLocalizations.of(context)!.feedbackViewDeviceInfo),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) =>
                _DetailedInfoDialog(details: _viewModel.appMetadata!),
          );
        },
      ),
      controlAffinity: ListTileControlAffinity.leading,
      subtitle: Text(AppLocalizations.of(context)!.feedbackAppMetadataSub),
      title: Text(AppLocalizations.of(context)!.feedbackAppMetadata),
      value: true,
      onChanged: null,
    );
  }

  Widget _buildSensitiveDataTile() {
    return CheckboxListTile(
      secondary: TextButton(
        child: Text(AppLocalizations.of(context)!.feedbackViewDeviceInfo),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) =>
                _DetailedInfoDialog(details: _viewModel.sensitiveData!),
          );
        },
      ),
      controlAffinity: ListTileControlAffinity.leading,
      subtitle: Text(AppLocalizations.of(context)!.feedbackSensitiveSub),
      title: Text(AppLocalizations.of(context)!.feedbackSensitive),
      value: _viewModel.isSensitiveChecked,
      onChanged: (value) => _viewModel.toggleSensitiveChecked(value!),
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
