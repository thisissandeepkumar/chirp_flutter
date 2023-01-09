import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState>? navigatorKey;

  static NavigationService instance = NavigationService();

  NavigationService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String routeName,
      [Map<String, dynamic>? arguments]) {
    return navigatorKey!.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateTo(String routeName,
      [Map<String, dynamic>? arguments]) {
    return navigatorKey!.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute routeName) {
    return navigatorKey!.currentState!.push(routeName);
  }

  void goBack() {
    return navigatorKey!.currentState!.pop();
  }
}
