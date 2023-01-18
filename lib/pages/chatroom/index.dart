import 'package:comms_flutter/constants.dart';
import 'package:comms_flutter/models/account.dart';
import 'package:comms_flutter/models/message.dart';
import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/providers/chatroom_provider.dart';
import 'package:comms_flutter/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatroomPage extends StatefulWidget {
  const ChatroomPage({super.key});

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  late AuthProvider authProvider;
  late ChatroomProvider chatroomProvider;
  late MessageProvider messageProvider;

  late io.Socket socket;

  late TextEditingController textContentController;

  @override
  void initState() {
    super.initState();
    textContentController = TextEditingController();
    MessageProvider.instance.fetchMessages();
    socket = io.io(
      "$chatCoreHost?room=${ChatroomProvider.instance.currentChatroom!.id}",
      io.OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .setExtraHeaders({
            "Authorization": "Bearer ${AuthProvider.instance.token}",
          })
          .build(),
    );
    socket.connect();
    socket.on("message", (data) {
      messageProvider.onMessageReceived(Message.fromJSON(data));
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    MessageProvider.instance.destroyChatroom();
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
                          child: messagesPreview(mainContext, messageProvider),
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
                                      socket.emit("message", {
                                        "type": "text",
                                        "textContent":
                                            textContentController.text
                                      });
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

  Widget messagesPreview(
      BuildContext buildContext, MessageProvider messageProvider) {
    return ListView.builder(
      itemCount: messageProvider.messages.length,
      itemBuilder: (buildContext, int index) {
        return Align(
          alignment: messageProvider.messages[index].senderId ==
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
              borderRadius: messageProvider.messages[index].senderId ==
                      AuthProvider.instance.currentUser!.id
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
              messageProvider.messages[index].textContent!,
              // style: const TextStyle(
              //   height: 35,
              // ),
            ),
          ),
        );
      },
    );
  }
}
