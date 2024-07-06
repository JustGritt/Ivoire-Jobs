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
    apiKey: 'AIzaSyARemSX1uXBA8ulMm-pd1lWq63dVEvcSdI',
    appId: '1:223752620189:web:4b2799717b5a34fdf4ac74',
    messagingSenderId: '223752620189',
    projectId: 'barassageapp',
    authDomain: 'barassageapp.firebaseapp.com',
    storageBucket: 'barassageapp.appspot.com',
    measurementId: 'G-NXSPH3XDCL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDv8ES5atdsZjeAMb_XM7oU1HWeXdW85Vc',
    appId: '1:223752620189:android:e4d2a809f5a499c5f4ac74',
    messagingSenderId: '223752620189',
    projectId: 'barassageapp',
    storageBucket: 'barassageapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOuw03zgGCpfHtFWa1GtIolSvc9PF5qZc',
    appId: '1:223752620189:ios:8a8907743a141713f4ac74',
    messagingSenderId: '223752620189',
    projectId: 'barassageapp',
    storageBucket: 'barassageapp.appspot.com',
    iosBundleId: 'app.barassage.com',
  );
}
