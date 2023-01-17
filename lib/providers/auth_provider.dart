import 'dart:convert';

import 'package:comms_flutter/constants.dart';
import 'package:comms_flutter/models/account.dart';
import 'package:comms_flutter/services/prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AuthStatus {
  isError,
  isAuthenticated,
  isUnauthenticated,
  isAuthenticating
}

class AuthProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.isUnauthenticated;
  Account? currentUser;
  String? token;

  static AuthProvider instance = AuthProvider();

  AuthProvider();

  Future<void> login(String email, String password) async {
    authStatus = AuthStatus.isAuthenticating;
    notifyListeners();
    try {
      http.Response response =
          await http.post(Uri.parse("$chatCoreHost/api/account/v1/login"),
              body: jsonEncode({
                "email": email,
                "password": password,
              }),
              headers: {
            "Content-Type": "application/json",
          });
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        currentUser = Account.fromJson(data["user"]);
        token = data["token"];
        authStatus = AuthStatus.isAuthenticated;
        await CommsSharedPreferenceService.setString("token", token!);
      }
    } catch (e) {
      authStatus = AuthStatus.isError;
      print(e);
    }
    notifyListeners();
  }

  Future<bool> checkPersistance() async {
    String? persistedToken =
        await CommsSharedPreferenceService.getString("token");
    if (persistedToken != null) {
      // TODO: Implement check persistance using APIs
      authStatus = AuthStatus.isAuthenticated;
      currentUser = Account(
        id: "jubnsidb80wehsyvc7afs76f6",
        firstName: "John",
        lastName: "Doe",
        email: "john.doe@gmail.com",
        createdAt: DateTime.now(),
      );
      token = persistedToken;
      //
      notifyListeners();
      return true;
    } else {
      authStatus = AuthStatus.isUnauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    authStatus = AuthStatus.isUnauthenticated;
    currentUser = null;
    token = null;
    await CommsSharedPreferenceService.clear("token");
    notifyListeners();
  }
}
