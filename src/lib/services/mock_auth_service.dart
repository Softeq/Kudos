import 'dart:async';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class MockAuthService extends BaseAuthService {
  Function(UserModel) _handler;

  @override
  UserModel get currentUser => UserModel.mock();

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
  void silentInit(Function(UserModel) userChangedHandler) async {
    _handler = userChangedHandler;

    await Future.delayed(Duration(seconds: 1));

    _handler(currentUser);
  }
}
