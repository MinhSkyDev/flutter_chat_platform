import 'dart:convert';

import 'package:chat_platform/model/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLoader {
  static final DataLoader _singleton = DataLoader._internal();

  factory DataLoader() {
    return _singleton;
  }

  String listListMessageToJson(List<List<Message>> messagesList) {
    final List<List<Map<String, dynamic>>> jsonListList = messagesList
        .map((messages) => messages.map((message) => message.toJson()).toList())
        .toList();

    return jsonEncode(jsonListList);
  }

  List<List<Message>> jsonToListListMessage(String jsonString) {
    final List<dynamic> dynamicListList = jsonDecode(jsonString);

    return dynamicListList.map((dynamicList) {
      if (dynamicList is List<dynamic>) {
        return dynamicList
            .map((dynamicMessage) => Message.fromJson(dynamicMessage))
            .toList();
      } else {
        throw const FormatException(
            'Invalid JSON format for List<List<Message>>');
      }
    }).toList();
  }

  Future<void> saveThread(List<List<Message>> list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ChatPlication', listListMessageToJson(list));
  }

  Future<List<List<Message>>> readThread() async {
    final prefs = await SharedPreferences.getInstance();
    String threadString = prefs.getString('ChatPlication') ?? "";
    if (threadString == "") {
      return [];
    }
    return jsonToListListMessage(threadString);
  }

  DataLoader._internal();
}
