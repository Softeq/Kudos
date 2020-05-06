import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/services/auth_service.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();

  User _currentUser;

  AuthViewModel() {
    _authService.silentInit((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User get currentUser => _currentUser;

  bool get isAuth => _currentUser != null;

  Future<void> signIn() async {
    await _authService.signIn();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}