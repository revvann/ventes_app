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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD-kZ0XlUXEsP38bVUi0x2vZDFkpfd3GIE',
    appId: '1:334711722504:web:5ac500a6e15064acdaf7bd',
    messagingSenderId: '334711722504',
    projectId: 'ventes-app-2d102',
    authDomain: 'ventes-app-2d102.firebaseapp.com',
    storageBucket: 'ventes-app-2d102.appspot.com',
    measurementId: 'G-DBM16PQM71',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2ip9iOsiOzYqSAiFFHMkRcl7mUaMG4BI',
    appId: '1:334711722504:android:9e04d955d3ac8e5cdaf7bd',
    messagingSenderId: '334711722504',
    projectId: 'ventes-app-2d102',
    storageBucket: 'ventes-app-2d102.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAoyIcjbn6NMFlQa32wbVEctyGNsbzGqL0',
    appId: '1:334711722504:ios:45a52c18526683bddaf7bd',
    messagingSenderId: '334711722504',
    projectId: 'ventes-app-2d102',
    storageBucket: 'ventes-app-2d102.appspot.com',
    androidClientId: '334711722504-j2s2ig0h8eokucth45pf4vf1ekds8nc7.apps.googleusercontent.com',
    iosClientId: '334711722504-bhfjbq9k4ke0vf2gg1dd0ecbejrq0jag.apps.googleusercontent.com',
    iosBundleId: 'com.example.ventes',
  );
}