import 'dart:async';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class MockAuthService extends BaseAuthService {
  Function(User) _handler;

  @override
  User get currentUser => User.mock();

  @override
  Future<void> signIn() async {
    await Future.delayed(Duration(seconds: 3));
    _handler(currentUser);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(Duration(seconds: 3));

    _handler(null);
  }

  @override
  void silentInit(Function(User) userChangedHandler) async {
    _handler = userChangedHandler;

    await Future.delayed(Duration(seconds: 1));

    _handler(currentUser);
  }
}
