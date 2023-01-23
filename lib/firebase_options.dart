// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCvUzs9VPZftGIXWH8mcHV4ittwDv1_uWI',
    appId: '1:1092006366982:web:30c47c84b659bf1ff01887',
    messagingSenderId: '1092006366982',
    projectId: 'comms-10c29',
    authDomain: 'comms-10c29.firebaseapp.com',
    storageBucket: 'comms-10c29.appspot.com',
    measurementId: 'G-VMVYL2895K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5yFiftYtr98eZ6BRcTGYA5KZzyYV7lt0',
    appId: '1:1092006366982:android:ec0e932a654d95baf01887',
    messagingSenderId: '1092006366982',
    projectId: 'comms-10c29',
    storageBucket: 'comms-10c29.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBQY-LDAZeG_o3CWLfVNVTgmNrUFCJaeM',
    appId: '1:1092006366982:ios:ad45ae2700aca615f01887',
    messagingSenderId: '1092006366982',
    projectId: 'comms-10c29',
    storageBucket: 'comms-10c29.appspot.com',
    iosClientId: '1092006366982-39eet68jtmj4i4mdiqkcujiair5s66rq.apps.googleusercontent.com',
    iosBundleId: 'in.sandeepkumar.commms',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDBQY-LDAZeG_o3CWLfVNVTgmNrUFCJaeM',
    appId: '1:1092006366982:ios:e11fba93e579063bf01887',
    messagingSenderId: '1092006366982',
    projectId: 'comms-10c29',
    storageBucket: 'comms-10c29.appspot.com',
    iosClientId: '1092006366982-g4uc1084cotct8e2sb42klpov3k296ih.apps.googleusercontent.com',
    iosBundleId: 'in.sandeepkumar.comms',
  );
}
