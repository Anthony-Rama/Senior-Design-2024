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
    apiKey: 'AIzaSyBEh4nvUsyXgito_uczA6gqUspHfMRrez8',
    appId: '1:1062001949517:web:96aad9bcaeffc8b6375504',
    messagingSenderId: '1062001949517',
    projectId: 'bellboard-2024',
    authDomain: 'bellboard-2024.firebaseapp.com',
    storageBucket: 'bellboard-2024.appspot.com',
    measurementId: 'G-H5CRST356T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBf5wIfnaabJW3Jqw9bJjVEbwXCSNNIOaw',
    appId: '1:1062001949517:android:1af68f7295001ef6375504',
    messagingSenderId: '1062001949517',
    projectId: 'bellboard-2024',
    storageBucket: 'bellboard-2024.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyApOlqjTrxEk6Y0-VKH1mGRs3bgzriWvmA',
    appId: '1:1062001949517:ios:8a7bb375928e2a6f375504',
    messagingSenderId: '1062001949517',
    projectId: 'bellboard-2024',
    storageBucket: 'bellboard-2024.appspot.com',
    iosBundleId: 'com.example.mobileapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyApOlqjTrxEk6Y0-VKH1mGRs3bgzriWvmA',
    appId: '1:1062001949517:ios:88dd6fc3985ea7d3375504',
    messagingSenderId: '1062001949517',
    projectId: 'bellboard-2024',
    storageBucket: 'bellboard-2024.appspot.com',
    iosBundleId: 'com.example.mobileapp.RunnerTests',
  );
}