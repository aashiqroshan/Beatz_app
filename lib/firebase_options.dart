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
    apiKey: 'AIzaSyCYoY1QevySIuhnY1ao_SuWgMXrvIfuPeY',
    appId: '1:598457195974:web:738e9a2ba64c5b4c16a6c7',
    messagingSenderId: '598457195974',
    projectId: 'beatz-music-app',
    authDomain: 'beatz-music-app.firebaseapp.com',
    databaseURL: 'https://beatz-music-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'beatz-music-app.appspot.com',
    measurementId: 'G-TRDT1NTGBY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfKAa2DJHKkEOH4LDO4qUGsHyPbNBoIXM',
    appId: '1:598457195974:android:88eafa02ff05993516a6c7',
    messagingSenderId: '598457195974',
    projectId: 'beatz-music-app',
    databaseURL: 'https://beatz-music-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'beatz-music-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDN1G7oiWIQY0cR-Gb-4KrLIbyGjQsgJ_g',
    appId: '1:598457195974:ios:7c011ee7f332bc5d16a6c7',
    messagingSenderId: '598457195974',
    projectId: 'beatz-music-app',
    databaseURL: 'https://beatz-music-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'beatz-music-app.appspot.com',
    iosBundleId: 'com.example.beatzMusicplayer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDN1G7oiWIQY0cR-Gb-4KrLIbyGjQsgJ_g',
    appId: '1:598457195974:ios:7c011ee7f332bc5d16a6c7',
    messagingSenderId: '598457195974',
    projectId: 'beatz-music-app',
    databaseURL: 'https://beatz-music-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'beatz-music-app.appspot.com',
    iosBundleId: 'com.example.beatzMusicplayer',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYoY1QevySIuhnY1ao_SuWgMXrvIfuPeY',
    appId: '1:598457195974:web:a53cf2242b7ecc8c16a6c7',
    messagingSenderId: '598457195974',
    projectId: 'beatz-music-app',
    authDomain: 'beatz-music-app.firebaseapp.com',
    databaseURL: 'https://beatz-music-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'beatz-music-app.appspot.com',
    measurementId: 'G-VH96LX9LFC',
  );

}