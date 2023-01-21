import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '',
        apiKey: '',
        projectId: '',
        messagingSenderId: '',
        iosBundleId: '',
        iosClientId: '',
        androidClientId: '',
        storageBucket: '',
        databaseURL: '',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:1075180396404:android:cd223bc7935542cfb99621',
        apiKey: 'AIzaSyAhqwkAdR3bqtlJtcPBJ3wyoj8k47ko4no',
        projectId: 'iscannerx',
        messagingSenderId: '1075180396404',
      );
    }
  }
}
