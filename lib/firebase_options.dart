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
    apiKey: 'AIzaSyDcuVLhHXIJOsZisExrMhyUcDVMOVEK7as',
    appId: '1:830220566331:web:fdd8a7e70124ba3ce4411e',
    messagingSenderId: '830220566331',
    projectId: 'chatting-room-6dfee',
    authDomain: 'chatting-room-6dfee.firebaseapp.com',
    storageBucket: 'chatting-room-6dfee.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQGft8SmrDxQQGCrojo1DQ5Vc524V3o38',
    appId: '1:830220566331:android:c2156c5eef05f6a8e4411e',
    messagingSenderId: '830220566331',
    projectId: 'chatting-room-6dfee',
    storageBucket: 'chatting-room-6dfee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1c78-mRVNqQ_yAwNu8KA-evNJjGvRmDw',
    appId: '1:830220566331:ios:09641b01ffc20e65e4411e',
    messagingSenderId: '830220566331',
    projectId: 'chatting-room-6dfee',
    storageBucket: 'chatting-room-6dfee.appspot.com',
    iosBundleId: 'com.khalafawy.chattingroom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA1c78-mRVNqQ_yAwNu8KA-evNJjGvRmDw',
    appId: '1:830220566331:ios:0d8ab804d777fb1ce4411e',
    messagingSenderId: '830220566331',
    projectId: 'chatting-room-6dfee',
    storageBucket: 'chatting-room-6dfee.appspot.com',
    iosBundleId: 'com.khalafawy.chattingroom.RunnerTests',
  );
}
