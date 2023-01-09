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
}
