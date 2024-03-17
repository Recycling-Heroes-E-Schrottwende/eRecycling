import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDkUndwTttTPlfX6ITnBE9KzUqkUcABlvo",
            authDomain: "diplomprojekt-hpolng.firebaseapp.com",
            projectId: "diplomprojekt-hpolng",
            storageBucket: "diplomprojekt-hpolng.appspot.com",
            messagingSenderId: "80415466885",
            appId: "1:80415466885:web:c5cdc80fe7a778331090ec"));
  } else {
    await Firebase.initializeApp();
  }
}
