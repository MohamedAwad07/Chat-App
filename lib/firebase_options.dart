// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['WEB_API_KEY'] ?? '',
    appId: '1:788342188841:web:4e4e2d02dabf3fc324a538',
    messagingSenderId: '788342188841',
    projectId: 'chat-app-7fa73',
    authDomain: 'chat-app-7fa73.firebaseapp.com',
    storageBucket: 'chat-app-7fa73.firebasestorage.app',
    measurementId: 'G-YX2LESLWF2',
  );

  static  FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['ANDROID_API_KEY'] ?? '',
    appId: '1:788342188841:android:440751f2ce567fcd24a538',
    messagingSenderId: '788342188841',
    projectId: 'chat-app-7fa73',
    storageBucket: 'chat-app-7fa73.firebasestorage.app',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['IOS_API_KEY'] ?? '',
    appId: '1:788342188841:ios:0e1e82c87916431c24a538',
    messagingSenderId: '788342188841',
    projectId: 'chat-app-7fa73',
    storageBucket: 'chat-app-7fa73.firebasestorage.app',
    iosClientId: '788342188841-vqbuj1j19ka4h8v4v61911oj0088ikef.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['MACOS_API_KEY'] ?? '',
    appId: '1:788342188841:ios:0e1e82c87916431c24a538',
    messagingSenderId: '788342188841',
    projectId: 'chat-app-7fa73',
    storageBucket: 'chat-app-7fa73.firebasestorage.app',
    iosClientId: '788342188841-vqbuj1j19ka4h8v4v61911oj0088ikef.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );

  
}
