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
    apiKey: 'AIzaSyBcSeYmqrYZ8GcgZnpxT0wbnGlg3IY4_8k',
    appId: '1:244190624368:web:5930568b14d386a3af92b5',
    messagingSenderId: '244190624368',
    projectId: 'cabbooking-e2013',
    authDomain: 'cabbooking-e2013.firebaseapp.com',
    databaseURL: 'https://cabbooking-e2013-default-rtdb.firebaseio.com',
    storageBucket: 'cabbooking-e2013.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSwA_WrYl5QXoRqaFC6EfMFeIcfFCR0Jc',
    appId: '1:244190624368:android:8c3e291953833935af92b5',
    messagingSenderId: '244190624368',
    projectId: 'cabbooking-e2013',
    databaseURL: 'https://cabbooking-e2013-default-rtdb.firebaseio.com',
    storageBucket: 'cabbooking-e2013.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZnyUWFeSBU53bCT-3WU1aseHcb_HuC5U',
    appId: '1:244190624368:ios:6473c597c2f7edb9af92b5',
    messagingSenderId: '244190624368',
    projectId: 'cabbooking-e2013',
    databaseURL: 'https://cabbooking-e2013-default-rtdb.firebaseio.com',
    storageBucket: 'cabbooking-e2013.appspot.com',
    iosBundleId: 'com.example.nansuDriver',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZnyUWFeSBU53bCT-3WU1aseHcb_HuC5U',
    appId: '1:244190624368:ios:9af12ef80cd345a9af92b5',
    messagingSenderId: '244190624368',
    projectId: 'cabbooking-e2013',
    databaseURL: 'https://cabbooking-e2013-default-rtdb.firebaseio.com',
    storageBucket: 'cabbooking-e2013.appspot.com',
    iosBundleId: 'com.example.nansuDriver.RunnerTests',
  );
}
