import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class MyProfileViewModel extends BaseViewModel {
  final BaseAuthService _authService = locator<BaseAuthService>();

  User get user => _authService.currentUser;

  Future<void> signOut() => _authService.signOut();
}