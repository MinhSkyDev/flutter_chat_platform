import 'dart:convert';

import 'package:chat_platform/model/message.dart';
import 'package:http/http.dart' as http;

class GPTCaller {
  static final GPTCaller _singleton = GPTCaller._internal();

  factory GPTCaller() {
    return _singleton;
  }

  Map<String, dynamic> createRequestDataFromMessageList(List<Message> lst) {
    final List<Map<String, dynamic>> messages =
        lst.map((message) => message.toJson()).toList();

    return {"model": "gpt-3.5-turbo", 'messages': messages};
  }

  Future<String> callOpenAIToGetMessage(
      Map<String, dynamic> requestData) async {
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';
    const String openaiApiKey =
        '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';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openaiApiKey',
    };

    String messageContent = "Error";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        messageContent = jsonResponse['choices'][0]['message']['content'];
      }
    } catch (error) {
      return error.toString();
    }

    return messageContent;
  }

  GPTCaller._internal();
}
