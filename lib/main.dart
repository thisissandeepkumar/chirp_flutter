import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:comms_flutter/controllers/notification_controller.dart';
import 'package:comms_flutter/pages/call/index.dart';
import 'package:comms_flutter/pages/chatroom/index.dart';
import 'package:comms_flutter/pages/home/index.dart';
import 'package:comms_flutter/pages/login/index.dart';
import 'package:comms_flutter/pages/splash/index.dart';
import 'package:comms_flutter/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: "basic_channel",
          channelName: "Basic Notifications",
          channelDescription: "Notifications for basic tests"),
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

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
        "call": (context) => const CallPage(),
      },
      initialRoute: "splash",
    );
  }
}
