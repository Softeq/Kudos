import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  final _authService = locator<BaseAuthService>();

  PeopleService _peopleService;
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

  PeopleService get peopleService {
    if (_peopleService == null) {
      _peopleService = locator<PeopleService>();
    }

    return _peopleService;
  }

  User get currentUser => _currentUser;

  AuthViewModelState get authState => _authState;

  set authState(AuthViewModelState state) {
    _authState = state;
    notifyListeners();
  }

  Future<void> signIn() async {
    await _authService.signIn();
    await peopleService.tryRegisterCurrentUser();
  }

  Future<void> signOut() async {
    await peopleService.unsubscribeFromNotifications();
    await _authService.signOut();
  }
}

enum AuthViewModelState {
  unknown,
  loggedIn,
  loggedOut,
}
