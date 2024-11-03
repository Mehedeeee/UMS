// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyD9z2Pod0McYkxbNWL4M4VbMb9dNr52LYs',
    appId: '1:868186722477:web:4a1ae1ad04da404f23f624',
    messagingSenderId: '868186722477',
    projectId: 'umsnotificationseu',
    authDomain: 'umsnotificationseu.firebaseapp.com',
    storageBucket: 'umsnotificationseu.appspot.com',
    measurementId: 'G-D87TJ2N9K9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtNKEbHJHHLmKLZNGn-O8OirPLYVCSOrI',
    appId: '1:868186722477:android:ac310d3e2edf1cad23f624',
    messagingSenderId: '868186722477',
    projectId: 'umsnotificationseu',
    storageBucket: 'umsnotificationseu.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4WLAMH89vKGA96TRXCwSI70GnqA7DKTY',
    appId: '1:868186722477:ios:3cb780bd6bb40cf323f624',
    messagingSenderId: '868186722477',
    projectId: 'umsnotificationseu',
    storageBucket: 'umsnotificationseu.appspot.com',
    iosBundleId: 'bd.edu.seu.ums',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4WLAMH89vKGA96TRXCwSI70GnqA7DKTY',
    appId: '1:868186722477:ios:3cb780bd6bb40cf323f624',
    messagingSenderId: '868186722477',
    projectId: 'umsnotificationseu',
    storageBucket: 'umsnotificationseu.appspot.com',
    iosBundleId: 'bd.edu.seu.ums',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD9z2Pod0McYkxbNWL4M4VbMb9dNr52LYs',
    appId: '1:868186722477:web:e4a3fec5052328ae23f624',
    messagingSenderId: '868186722477',
    projectId: 'umsnotificationseu',
    authDomain: 'umsnotificationseu.firebaseapp.com',
    storageBucket: 'umsnotificationseu.appspot.com',
    measurementId: 'G-SKWCRQQ013',
  );

}