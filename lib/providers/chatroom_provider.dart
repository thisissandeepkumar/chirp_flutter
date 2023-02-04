import 'dart:convert';

import 'package:comms_flutter/constants.dart';
import 'package:comms_flutter/models/chatroom.dart';
import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;

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

  io.Socket? socket;

  static ChatroomProvider instance = ChatroomProvider();

  ChatroomProvider();

  Future<void> establishSocketConnection() async {
    socket = io.io(
      chatCoreHost,
      io.OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .setExtraHeaders({
            "Authorization": "Bearer ${AuthProvider.instance.token}",
          })
          .build(),
    );
    socket!.connect();
  }

  Future<void> listenToEvent(
      String event, dynamic Function(dynamic data) onEventHandler) async {
    socket!.on(event, onEventHandler);
  }

  Future<void> fetchChatrooms() async {
    state = ChatroomState.loading;

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

  void setCurrentChatroom(Chatroom chatroom) {
    currentChatroom = chatroom;
    socket!.emit("join", {
      "chatroomId": currentChatroom!.id,
    });
    notifyListeners();
  }

  void leaveChatroom() {
    socket!.emit("leave", {
      "chatroomId": currentChatroom!.id,
    });
    currentChatroom = null;
    notifyListeners();
  }

  void destroySocketConnection() {
    socket!.disconnect();
    socket!.dispose();
    socket = null;
    notifyListeners();
  }
}
