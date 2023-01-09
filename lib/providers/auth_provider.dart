import 'package:comms_flutter/models/account.dart';
import 'package:comms_flutter/services/prefs_service.dart';
import 'package:flutter/material.dart';

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
    // TODO: Implement login using APIs
    authStatus = AuthStatus.isAuthenticated;
    currentUser = Account(
      id: "jubnsidb80wehsyvc7afs76f6",
      firstName: "John",
      lastName: "Doe",
      email: "john.doe@gmail.com",
      createdAt: DateTime.now(),
    );
    CommsSharedPreferenceService.setString("token", "insdch98shdcsd");
    token = "insdch98shdcsd";
    //
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
}
