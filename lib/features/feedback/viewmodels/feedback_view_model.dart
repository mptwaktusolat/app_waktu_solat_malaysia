import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../constants.dart';
import '../../../location_utils/location_data.dart';
import '../services/feedback_submission_service.dart';

class FeedbackViewModel extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic>? deviceInfo;
  Map<String, dynamic>? appMetadata;
  Map<String, dynamic>? sensitiveData;

  bool isSendLoading = false;
  bool logIsChecked = true;
  bool isSensitiveChecked = false;

  FeedbackViewModel() {
    _initSensitiveData();
  }

  void _initSensitiveData() {
    sensitiveData = {
      'Recent GPS':
          '${LocationData.position?.latitude},${LocationData.position?.longitude}',
    };
  }

  void toggleLogChecked(bool value) {
    logIsChecked = value;
    notifyListeners();
  }

  void toggleSensitiveChecked(bool value) {
    isSensitiveChecked = value;
    notifyListeners();
  }

  Future<bool> validateAndSubmitFeedback(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      isSendLoading = true;
      notifyListeners();

      try {
        debugPrint('Sending feedback...');
        await FeedbackSubmissionService.submitFeedback(
          messageController.text.trim(),
          email: emailController.text.trim(),
          otherPayloads: {
            'app_info': appMetadata,
            if (logIsChecked) 'device_info': deviceInfo,
            if (isSensitiveChecked) 'additional_info': sensitiveData,
            'platform_info': {
              'platform': 'Flutter',
              'channel': FlutterVersion.channel,
              'version': FlutterVersion.version,
              'dart_sdk': FlutterVersion.dartVersion,
            },
          },
        );

        isSendLoading = false;
        notifyListeners();
        return true;
      } catch (e) {
        isSendLoading = false;
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  Future<void> loadDeviceInfo(BuildContext context) async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final androidInfo = await deviceInfoPlugin.androidInfo;

      deviceInfo = {
        'Android version': androidInfo.version.release,
        'Android Sdk': androidInfo.version.sdkInt,
        'Device': androidInfo.device,
        'Brand': androidInfo.brand,
        'Model': androidInfo.model,
        'Supported ABIs': androidInfo.supportedAbis,
        'Screen Sizes': MediaQuery.of(context).size.toString(),
        'Timezone': DateTime.now().timeZoneOffset.toString(),
        'Device Locale': Platform.localeName,
      };
    } catch (e) {
      log('Error loading device info: $e');
      deviceInfo = null;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadAppMetadata(BuildContext context, String locale) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      appMetadata = {
        'App version': packageInfo.version,
        'App build number': packageInfo.buildNumber,
        'zone': GetStorage().read(kStoredLocationJakimCode),
        'app locale': locale,
      };
    } catch (e) {
      log('Error loading app metadata: $e');
      appMetadata = null;
    } finally {
      notifyListeners();
    }
  }

  bool hasQuestionMark() {
    return messageController.text.contains('?');
  }

  bool isEmailEmpty() {
    return emailController.text.isEmpty;
  }

  @override
  void dispose() {
    messageController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
