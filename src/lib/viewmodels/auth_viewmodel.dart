import 'dart:async';

import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/session_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

enum AuthViewModelState {
  unknown,
  loggedIn,
  loggedOut,
}

class AuthViewModel extends BaseViewModel {
  final _authService = locator<BaseAuthService>();
  final _sessionService = locator<SessionService>();

  AuthViewModelState _authState = AuthViewModelState.unknown;

  AuthViewModel() {
    _authService.silentInit(
      (user) {
        authState = user == null
            ? AuthViewModelState.loggedOut
            : AuthViewModelState.loggedIn;
      },
    );
  }

  AuthViewModelState get authState => _authState;

  set authState(AuthViewModelState state) {
    _authState = state;
    notifyListeners();
  }

  Future<void> signIn() => _sessionService.startSession();

  Future<void> signOut() => _sessionService.closeSession();
}
