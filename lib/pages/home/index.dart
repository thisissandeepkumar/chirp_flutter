import 'dart:convert';

import 'package:comms_flutter/constants.dart';
import 'package:comms_flutter/models/account.dart';
import 'package:comms_flutter/models/chatroom.dart';
import 'package:comms_flutter/pages/profile/index.dart';
import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/providers/chatroom_provider.dart';
import 'package:comms_flutter/services/navigation_service.dart';
import 'package:comms_flutter/widgets/snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double width;
  late double height;
  late BuildContext mainContext;

  late AuthProvider authProvider;
  late ChatroomProvider chatroomProvider;

  late TextEditingController searchController;

  RemoteMessage? initialMessage;

  int _selectedPage = 0;
  int notificationIdCount = 0;

  Future<void> handleNotifications(RemoteMessage? remoteMessage) async {
    if (initialMessage == null) {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        initialMessage = message;
      });
    }
    if (initialMessage != null) {
      switch (initialMessage!.data["route"]) {
        case "/chatroom":
          await ChatroomProvider.instance.fetchChatrooms();
          ChatroomProvider.instance.setCurrentChatroom(chatroomProvider
              .chatrooms
              .where(
                  (element) => element.id == initialMessage!.data["chatroomId"])
              .first);
          NavigationService.instance.navigateTo("chatroom");
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    ChatroomProvider.instance.establishSocketConnection();
    ChatroomProvider.instance.fetchChatrooms();

    // Notifications Handling
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      // if (remoteMessage.data["chatroomId"] !=
      //     ChatroomProvider.instance.currentChatroom?.id) {
      //   AwesomeNotifications().createNotification(
      //     content: NotificationContent(
      //         id: ++notificationIdCount,
      //         channelKey: 'basic_channel',
      //         title: remoteMessage.notification!.title,
      //         body: remoteMessage.notification!.body),
      //   );
      // }
    });
    FirebaseMessaging.instance.getInitialMessage().then(handleNotifications);
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotifications);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider.instance,
        ),
        ChangeNotifierProvider.value(value: ChatroomProvider.instance),
      ],
      child: _mainUI(),
    ));
  }

  Widget _mainUI() {
    return Builder(builder: (BuildContext innerContext) {
      authProvider = Provider.of<AuthProvider>(innerContext);
      chatroomProvider = Provider.of<ChatroomProvider>(innerContext);
      mainContext = innerContext;
      return Scaffold(
        appBar: homeAppBar(),
        bottomNavigationBar: homeNavigationBar(),
        body: _centerPage(),
      );
    });
  }

  Widget _centerPage() {
    switch (_selectedPage) {
      case 0:
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: searchBar(
                searchController,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                left: 15,
              ),
              child: const Text(
                "Messages",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
                child: Container(
              child: chatroomProvider.state == ChatroomState.loading
                  ? const CircularProgressIndicator()
                  : chatroomProvider.state == ChatroomState.error
                      ? const Text("Error")
                      : ListView.builder(
                          itemBuilder: (mainContext, int index) {
                            late Account chatroom;
                            if (!chatroomProvider.chatrooms[index].isGroup) {
                              chatroom = chatroomProvider
                                  .chatrooms[index].participants
                                  .where((element) =>
                                      element.id !=
                                      authProvider.currentUser!.id)
                                  .first;
                            }
                            return ListTile(
                              onTap: () {
                                chatroomProvider.setCurrentChatroom(
                                    chatroomProvider.chatrooms[index]);
                                NavigationService.instance
                                    .navigateTo("chatroom");
                              },
                              title: Text(
                                chatroomProvider.chatrooms[index].isGroup
                                    ? chatroomProvider.chatrooms[index].title!
                                    : "${chatroom.firstName} ${chatroom.lastName}",
                              ),
                            );
                          },
                          itemCount: chatroomProvider.chatrooms.length,
                        ),
            )),
          ],
        );
      case 1:
        return const ProfilePage();
      default:
        return const ProfilePage();
    }
  }

  PreferredSizeWidget homeAppBar() {
    TextEditingController emailFieldController = TextEditingController();
    return AppBar(
      title: Text(
        _selectedPage == 0 ? "Messages" : "Profile",
      ),
      actions: [
        _selectedPage == 0
            ? IconButton(
                tooltip: "Start Chat",
                onPressed: () async {
                  return showDialog(
                    context: mainContext,
                    builder: (mainContext) {
                      return AlertDialog(
                        title: const Text("Start Chat"),
                        content: StatefulBuilder(
                          builder: (mainContext, StateSetter alertStateSetter) {
                            return TextFormField(
                              controller: emailFieldController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: "Email",
                              ),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              SnackBarService.instance.context = mainContext;
                              if (emailFieldController.text.isNotEmpty) {
                                try {
                                  http.Response response = await http.post(
                                    Uri.parse("$chatCoreHost/api/chatroom/v1"),
                                    headers: {
                                      "Content-Type": "application/json",
                                      "Authorization":
                                          "Bearer ${authProvider.token}",
                                    },
                                    body: jsonEncode({
                                      "email": emailFieldController.text,
                                    }),
                                  );
                                  if (response.statusCode == 201) {
                                    chatroomProvider.chatrooms.add(
                                      Chatroom.fromJson(
                                          jsonDecode(response.body)
                                              as Map<String, dynamic>),
                                    );
                                    chatroomProvider.setCurrentChatroom(
                                      chatroomProvider.chatrooms.last,
                                    );
                                    NavigationService.instance
                                        .navigateTo("chatroom");
                                  } else if (response.statusCode == 404) {
                                    SnackBarService.instance
                                        .showFailureSnackBar("User not found");
                                  } else if (response.statusCode == 409) {
                                    chatroomProvider.setCurrentChatroom(
                                      chatroomProvider.chatrooms.firstWhere(
                                          (element) =>
                                              element.id ==
                                              jsonDecode(response.body)[
                                                  "chatroom"]["_id"]),
                                    );
                                    NavigationService.instance
                                        .navigateTo("chatroom");
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(mainContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        e.toString(),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                SnackBarService.instance.context = mainContext;
                                SnackBarService.instance.showFailureSnackBar(
                                    "Please enter an email address");
                              }
                            },
                            child: const Text(
                              "Initiate",
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.message_rounded,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  // Individual Widgets
  Widget searchBar(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      onChanged: (String? searchValue) {
        // TODO: Search Logic to be implemented
      },
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget homeNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: "Messages",
          icon: Icon(
            Icons.message,
          ),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(
            Icons.account_circle,
          ),
        ),
      ],
      currentIndex: _selectedPage,
      onTap: (int? value) {
        if (value != null) {
          setState(() {
            _selectedPage = value;
          });
        }
      },
    );
  }
}
