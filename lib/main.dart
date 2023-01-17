import 'package:comms_flutter/pages/chatroom/index.dart';
import 'package:comms_flutter/pages/home/index.dart';
import 'package:comms_flutter/pages/login/index.dart';
import 'package:comms_flutter/pages/splash/index.dart';
import 'package:comms_flutter/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
        background: Container(
          color: const Color(0xFFF5F5F5),
        ),
      ),
      navigatorKey: NavigationService.instance.navigatorKey,
      title: 'Comms',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          shadowColor: Colors.transparent,
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 26,
          ),
          iconTheme: IconThemeData(
            color: Colors.green,
          ),
        ),
      ),
      routes: {
        "splash": (context) => const SplashScreen(),
        "login": (context) => const LoginScreen(),
        "home": (context) => const HomePage(),
        "chatroom": (context) => const ChatroomPage(),
      },
      initialRoute: "splash",
    );
  }
}
