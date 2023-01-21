import 'package:comms_flutter/providers/auth_provider.dart';
import 'package:comms_flutter/services/navigation_service.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            AuthProvider.instance.logout();
            NavigationService.instance.navigateToReplacement("login");
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
