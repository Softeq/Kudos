import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _auth = AuthService();

  User _currentUser;

  AuthViewModel() {
    _auth.silentInit((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User get currentUser => _currentUser;

  bool get isAuth => _currentUser != null;

  void signIn() async {
    await _auth.signIn();
  }

  void signOut() async {
    await _auth.signOut();

    _currentUser = null;
    notifyListeners();
  }
}