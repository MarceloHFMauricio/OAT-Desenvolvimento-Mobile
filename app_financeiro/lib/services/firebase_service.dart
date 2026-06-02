import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCG7tNfBXHAHQV1vaBs72VupbH_PD2rRMs",
    authDomain: "oat-2-desenvolvimento-mobile.firebaseapp.com",
    databaseURL: "https://oat-2-desenvolvimento-mobile-default-rtdb.firebaseio.com",
    projectId: "oat-2-desenvolvimento-mobile",
    storageBucket: "oat-2-desenvolvimento-mobile.firebasestorage.app",
    messagingSenderId: "719107898171",
    appId: "1:719107898171:web:122fa49bc175f63797951e",
  );
}
