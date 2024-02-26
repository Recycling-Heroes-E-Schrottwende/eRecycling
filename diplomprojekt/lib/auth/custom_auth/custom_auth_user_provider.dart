import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class DiplomprojektAuthUser {
  DiplomprojektAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<DiplomprojektAuthUser> diplomprojektAuthUserSubject =
    BehaviorSubject.seeded(DiplomprojektAuthUser(loggedIn: false));
Stream<DiplomprojektAuthUser> diplomprojektAuthUserStream() =>
    diplomprojektAuthUserSubject
        .asBroadcastStream()
        .map((user) => currentUser = user);
