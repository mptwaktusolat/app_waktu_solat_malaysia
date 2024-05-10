import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../env.dart';

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

    final feedbackApiUri = Uri.https(envApiBaseHost).resolve('/api/feedback');

    await http.post(
      feedbackApiUri,
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.toString()},
      body: jsonEncode(body),
    );
  }
}
