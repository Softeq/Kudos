import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';

class MyProfileViewModel extends BaseViewModel {
  final AuthViewModel auth;
  final ProfileViewModel profile;

  MyProfileViewModel(this.auth, this.profile);
}