import 'package:comms_flutter/pages/login/index.dart';
import 'package:comms_flutter/pages/splash/index.dart';
import 'package:comms_flutter/services/navigation_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.instance.navigatorKey,
      title: 'Comms',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "splash": (context) => const SplashScreen(),
        "login": (context) => const LoginScreen(),
      },
      initialRoute: "splash",
    );
  }
}
