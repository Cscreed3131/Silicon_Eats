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
    apiKey: 'AIzaSyAcm0ogGI3krsglVrSr2MY3qn_HWuwv9RY',
    appId: '1:803043140939:web:433d2709ebe4c927e674ce',
    messagingSenderId: '803043140939',
    projectId: 'sora-summit',
    authDomain: 'sora-summit.firebaseapp.com',
    storageBucket: 'sora-summit.appspot.com',
    measurementId: 'G-MNYEBRKLEQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAqk1J2Au61MgwHu_IXpkpykiUqdOIJ66M',
    appId: '1:803043140939:android:84dbf0c0a19a5032e674ce',
    messagingSenderId: '803043140939',
    projectId: 'sora-summit',
    storageBucket: 'sora-summit.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6sgwxHa57s1w6vOSgi1kCG1j7MbvZGIU',
    appId: '1:803043140939:ios:59ed061d69f798cae674ce',
    messagingSenderId: '803043140939',
    projectId: 'sora-summit',
    storageBucket: 'sora-summit.appspot.com',
    iosBundleId: 'com.example.sorasummit',
  );
}
