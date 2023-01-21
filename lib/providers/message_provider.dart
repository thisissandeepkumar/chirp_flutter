import 'dart:convert';

import 'package:comms_flutter/constants.dart';
import 'package:comms_flutter/models/message.dart';
import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/providers/chatroom_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

enum MessageState { idle, loading, loaded, error }

class MessageProvider extends ChangeNotifier {
  List<Message> messages = [];
  MessageState state = MessageState.idle;

  static MessageProvider instance = MessageProvider();

  MessageProvider();

  Future<void> fetchMessages() async {
    if (ChatroomProvider.instance.currentChatroom != null) {
      state = MessageState.loading;
      notifyListeners();
      try {
        http.Response response = await http.get(
            Uri.parse(
                "$chatCoreHost/api/message/v1?chatroomId=${ChatroomProvider.instance.currentChatroom!.id}"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${AuthProvider.instance.token}"
            });
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body) as List<dynamic>;
          messages = data.map((e) => Message.fromJSON(e)).toList();
          messages.sort((b, a) => a.createdAt!.compareTo(b.createdAt!));
          state = MessageState.loaded;
          notifyListeners();
        } else {
          state = MessageState.error;
          notifyListeners();
        }
      } catch (e) {
        print(e);
        state = MessageState.error;
        notifyListeners();
      }
    }
  }

  void destroyChatroom() {
    messages = [];
    state = MessageState.idle;
  }

  void onMessageReceived(Message message) {
    messages.add(message);
    notifyListeners();
  }
}
