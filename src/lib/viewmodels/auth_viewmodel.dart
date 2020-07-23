import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

enum AuthViewModelState {
  unknown,
  loggedIn,
  loggedOut,
}

class AuthViewModel extends BaseViewModel {
  final _authService = locator<BaseAuthService>();
  final _peopleService = locator<PeopleService>();

  AuthViewModelState _authState = AuthViewModelState.unknown;

  AuthViewModel() {
    _authService.silentInit((user) {
      authState = user == null
          ? AuthViewModelState.loggedOut
          : AuthViewModelState.loggedIn;
    });
  }

  AuthViewModelState get authState => _authState;

  set authState(AuthViewModelState state) {
    _authState = state;
    notifyListeners();
  }

  Future<void> signIn() async {
    await _authService.signIn();
    await _peopleService.tryRegisterCurrentUser();
  }

  Future<void> signOut() async {
    await _peopleService.unsubscribeFromNotifications();
    await _authService.signOut();
  }
}
