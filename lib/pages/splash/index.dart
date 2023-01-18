import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/services/navigation_service.dart';
import 'package:comms_flutter/services/prefs_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Comms'),
      ),
    );
  }
}
