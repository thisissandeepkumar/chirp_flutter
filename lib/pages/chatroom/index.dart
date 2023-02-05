import 'package:comms_flutter/models/account.dart';
import 'package:comms_flutter/models/message.dart';
import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/providers/chatroom_provider.dart';
import 'package:comms_flutter/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';
import 'package:provider/provider.dart';

class ChatroomPage extends StatefulWidget {
  const ChatroomPage({super.key});

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  late AuthProvider authProvider;
  late ChatroomProvider chatroomProvider;
  late MessageProvider messageProvider;

  late TextEditingController textContentController;
  ScrollController scrollController = ScrollController();

  int eventCount = 0;

  @override
  void initState() {
    super.initState();
    textContentController = TextEditingController();
    MessageProvider.instance.fetchMessages();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        await MessageProvider.instance.fetchMore();
      }
    });
  }

  @override
  void dispose() {
    MessageProvider.instance.destroyChatroom();
    ChatroomProvider.instance.leaveChatroom();
    scrollController.dispose();
    textContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: AuthProvider.instance),
          ChangeNotifierProvider.value(value: ChatroomProvider.instance),
          ChangeNotifierProvider.value(value: MessageProvider.instance),
        ],
        child: _mainUI(),
      ),
    );
  }

  Widget _mainUI() {
    return Builder(builder: (BuildContext mainContext) {
      authProvider = Provider.of<AuthProvider>(mainContext);
      chatroomProvider = Provider.of<ChatroomProvider>(mainContext);
      messageProvider = Provider.of<MessageProvider>(mainContext);
      late String title;
      if (chatroomProvider.currentChatroom!.isGroup) {
        title = chatroomProvider.currentChatroom!.title!;
      } else {
        Account otherAccount = chatroomProvider.currentChatroom!.participants
            .where((element) => element.id != authProvider.currentUser!.id)
            .first;
        title = "${otherAccount.firstName} ${otherAccount.lastName}";
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: messageProvider.state == MessageState.loading
            ? const CircularProgressIndicator()
            : messageProvider.state == MessageState.loaded
                ? Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 9,
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: messageProvider.messages.length,
                            reverse: true,
                            itemBuilder: (mainContext, int index) {
                              return Align(
                                alignment: messageProvider
                                            .messages[index].senderId ==
                                        AuthProvider.instance.currentUser!.id
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: messageProvider
                                                .messages[index].senderId ==
                                            AuthProvider
                                                .instance.currentUser!.id
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )
                                        : const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                  ),
                                  child: Text(
                                    messageProvider
                                        .messages[index].textContent!,
                                    // style: const TextStyle(
                                    //   height: 35,
                                    // ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: TextFormField(
                                  controller: textContentController,
                                  decoration: const InputDecoration(
                                    hintText: "Type a message",
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () async {
                                    if (textContentController.text.isNotEmpty) {
                                      ChatroomProvider.instance
                                          .emitEvent("message", {
                                        "type": "text",
                                        "textContent":
                                            textContentController.text,
                                        "chatroomId": chatroomProvider
                                            .currentChatroom!.id,
                                      });
                                      // messageProvider.onMessageReceived(Message(
                                      //   chatroomId: ObjectId.fromTimestamp(
                                      //           DateTime.now())
                                      //       .hexString,
                                      //   senderId: authProvider.currentUser!.id,
                                      //   type: MessageType.text,
                                      //   textContent: textContentController.text,
                                      // ));
                                      textContentController.clear();
                                    }
                                  },
                                  icon: const Icon(Icons.send),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text("error"),
      );
    });
  }

  // Widget messagesPreview(
  //     BuildContext buildContext, MessageProvider messageProvider) {
  //   return
  // }
}
