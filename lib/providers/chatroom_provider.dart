import 'dart:convert';

import 'package:comms_flutter/constants.dart';
import 'package:comms_flutter/models/chatroom.dart';
import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum ChatroomState {
  idle,
  loading,
  loaded,
  error,
}

class ChatroomProvider extends ChangeNotifier {
  List<Chatroom> chatrooms = [];
  Chatroom? currentChatroom;
  ChatroomState state = ChatroomState.idle;

  static ChatroomProvider instance = ChatroomProvider();

  ChatroomProvider();

  Future<void> fetchChatrooms() async {
    state = ChatroomState.loading;
    notifyListeners();

    try {
      http.Response response =
          await http.get(Uri.parse("$chatCoreHost/api/chatroom/v1"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AuthProvider.instance.token}"
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        chatrooms = (data as List).map((e) => Chatroom.fromJson(e)).toList();
        state = ChatroomState.loaded;
        notifyListeners();
      } else {
        state = ChatroomState.error;
        notifyListeners();
      }
    } catch (e) {
      state = ChatroomState.error;
      notifyListeners();
    }

    notifyListeners();
  }
}
