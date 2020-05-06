import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/services/auth_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();

  User _currentUser;

  AuthViewModel() {
    _authService.silentInit((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User get currentUser => _currentUser ?? User("", "", "");

  bool get isAuth => _currentUser != null;

  Future<void> signIn() async {
    await _authService.signIn();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
