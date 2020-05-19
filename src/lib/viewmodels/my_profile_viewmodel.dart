import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class MyProfileViewModel extends BaseViewModel {
  final AuthViewModel _auth;

  MyProfileViewModel(this._auth);

  User get user => _auth.currentUser;

  Future<void> signOut() => _auth.signOut();
}