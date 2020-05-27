import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  final _authService = locator<BaseAuthService>();
  final _peopleService = locator<PeopleService>();

  User _currentUser;
  AuthViewModelState _authState = AuthViewModelState.unknown;

  AuthViewModel() {
    _authService.silentInit((user) {
      _currentUser = user;
      authState = _currentUser == null
          ? AuthViewModelState.loggedOut
          : AuthViewModelState.loggedIn;
    });
  }

  User get currentUser => _currentUser;

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
    await _peopleService.unSubscribeFromNotifications();
    await _authService.signOut();
  }
}

enum AuthViewModelState {
  unknown,
  loggedIn,
  loggedOut,
}
