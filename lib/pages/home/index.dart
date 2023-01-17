import 'package:comms_flutter/pages/profile/index.dart';
import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/providers/chatroom_provider.dart';
import 'package:comms_flutter/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double width;
  late double height;

  late AuthProvider authProvider;

  late TextEditingController searchController;

  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    ChatroomProvider.instance.fetchChatrooms();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomNavigationBar: homeNavigationBar(),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: AuthProvider.instance,
            ),
          ],
          child: _mainUI(),
        ));
  }

  Widget _mainUI() {
    return Builder(builder: (BuildContext innerContext) {
      authProvider = Provider.of<AuthProvider>(innerContext);
      switch (_selectedPage) {
        case 0:
          return Scaffold(
            appBar: homeAppBar(),
            body: Column(
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
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                )),
              ],
            ),
          );
        case 1:
          return const ProfilePage();
        default:
          return const ProfilePage();
      }
    });
  }

  PreferredSizeWidget homeAppBar() {
    return AppBar(
      title: const Text(
        "Messages",
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await authProvider.logout();
            NavigationService.instance.navigateToReplacement("login");
          },
          icon: const Icon(
            Icons.message_rounded,
          ),
        ),
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
