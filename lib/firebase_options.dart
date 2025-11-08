import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyB4ILFWFEJL1A6LikkXyPuMz3g0JpcKj7E',
    appId: '1:917083703355:web:077b56942cfb172e90f41e',
    messagingSenderId: '917083703355',
    projectId: 'bledsoetech-785b0',
    authDomain: 'bledsoetech-785b0.firebaseapp.com',
    storageBucket: 'bledsoetech-785b0.firebasestorage.app',
    measurementId: 'G-FNV16KYWLV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4ILFWFEJL1A6LikkXyPuMz3g0JpcKj7E',
    appId: '1:917083703355:android:077b56942cfb172e90f41e',
    messagingSenderId: '917083703355',
    projectId: 'bledsoetech-785b0',
    storageBucket: 'bledsoetech-785b0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4ILFWFEJL1A6LikkXyPuMz3g0JpcKj7E',
    appId: '1:917083703355:ios:077b56942cfb172e90f41e',
    messagingSenderId: '917083703355',
    projectId: 'bledsoetech-785b0',
    storageBucket: 'bledsoetech-785b0.firebasestorage.app',
    iosBundleId: 'com.bledsotech.iot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB4ILFWFEJL1A6LikkXyPuMz3g0JpcKj7E',
    appId: '1:917083703355:ios:077b56942cfb172e90f41e',
    messagingSenderId: '917083703355',
    projectId: 'bledsoetech-785b0',
    storageBucket: 'bledsoetech-785b0.firebasestorage.app',
    iosBundleId: 'com.bledsotech.iot',
  );
}