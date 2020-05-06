import 'package:kudosapp/models/user.dart';

abstract class BaseAuthService {

  User get currentUser;

  void silentInit(callback);

  Future<void> signIn();

  Future<void> signOut();

}