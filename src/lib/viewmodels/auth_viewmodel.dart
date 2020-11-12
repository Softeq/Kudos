import 'dart:async';

import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/mandatory_update_database_service.dart';
import 'package:kudosapp/services/session_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

enum AuthViewModelState {
  unknown,
  loggedIn,
  loggedOut,
  needUpdate,
}

class AuthViewModel extends BaseViewModel {
  final _authService = locator<BaseAuthService>();
  final _sessionService = locator<SessionService>();
  final _mandatoryUpdateDatabaseService =
      locator<MandatoryUpdateDatabaseService>();

  AuthViewModelState _authState = AuthViewModelState.unknown;
  StreamSubscription<bool> _appUpdateSubscription;

  AuthViewModel() {
    _authService.silentInit(
      (user) {
        authState = user == null
            ? AuthViewModelState.loggedOut
            : AuthViewModelState.loggedIn;
      },
    );

    _appUpdateSubscription =
        _mandatoryUpdateDatabaseService.needUpdateAppStream.listen(
      (needUpdate) {
        if (needUpdate) {
          authState = AuthViewModelState.needUpdate;
        }
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

  @override
  void dispose() {
    _appUpdateSubscription.cancel();
    super.dispose();
  }
}
