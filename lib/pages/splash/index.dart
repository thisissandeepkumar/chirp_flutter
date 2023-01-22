import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/services/navigation_service.dart';
import 'package:comms_flutter/services/prefs_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    Future.delayed(const Duration(seconds: 1), () async {
      bool isAuthenticated = await AuthProvider.instance.checkPersistance();
      if (isAuthenticated) {
        NavigationService.instance.navigateToReplacement("home");
      } else {
        CommsSharedPreferenceService.clear(null);
        NavigationService.instance.navigateToReplacement("login");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkNotificationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Comms'),
      ),
    );
  }
}
