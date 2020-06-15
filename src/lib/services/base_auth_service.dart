import 'package:kudosapp/dto/user.dart';

abstract class BaseAuthService {
  User get currentUser;

  void silentInit(Function(User) userChangedHandler);

  Future<void> signIn();

  Future<void> signOut();
}
