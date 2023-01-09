import 'package:comms_flutter/providers/auth_provider.dart';
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

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
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
      ],
      child: _mainUI(),
    ));
  }

  Widget _mainUI() {
    return Builder(builder: (BuildContext innerContext) {
      authProvider = Provider.of<AuthProvider>(innerContext);
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
          ],
        ),
      );
    });
  }

  PreferredSizeWidget homeAppBar() {
    return AppBar(
      title: const Text(
        "Messages",
      ),
      actions: [
        IconButton(
          onPressed: () {},
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
}
