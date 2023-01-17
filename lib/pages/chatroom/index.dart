import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/providers/chatroom_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatroomPage extends StatefulWidget {
  const ChatroomPage({super.key});

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  late AuthProvider authProvider;
  late ChatroomProvider chatroomProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: AuthProvider.instance),
          ChangeNotifierProvider.value(value: ChatroomProvider.instance),
        ],
        child: _mainUI(),
      ),
    );
  }

  Widget _mainUI() {
    return Builder(builder: (BuildContext mainContext) {
      authProvider = Provider.of<AuthProvider>(mainContext);
      chatroomProvider = Provider.of<ChatroomProvider>(mainContext);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            chatroomProvider.currentChatroom!.isGroup
                ? chatroomProvider.currentChatroom!.title!
                : chatroomProvider.currentChatroom!.participants
                    .where(
                        (element) => element.id != authProvider.currentUser!.id)
                    .first
                    .firstName,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}
