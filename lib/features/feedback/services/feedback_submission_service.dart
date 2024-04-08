import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../constants.dart';

class FeedbackSubmissionService {
  static Future<void> submitFeedback(String message,
      {String? email, Map<String, dynamic>? otherPayloads}) async {
    final payload = {
      'User email': email,
      'User message': message,
    };

    final body = {
      ...payload,
      if (otherPayloads != null) ...otherPayloads,
    };

    await http.post(Uri.https(kApiBaseUrl, '/api/feedback'),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.toString()},
        body: jsonEncode(body));
  }
}
