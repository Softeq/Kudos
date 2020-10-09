import 'package:kudosapp/helpers/disposable.dart';
import 'package:kudosapp/models/errors/auth_error.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/analytics_service.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class LoginViewModel extends BaseViewModel with Disposable {
  final AuthViewModel _authViewModel;
  final _analyticsService = locator<AnalyticsService>();

  LoginViewModel(this._authViewModel);

  Future<void> signIn(void Function(String) onAuthError) async {
    isBusy = true;
    try {
      await _authViewModel.signIn();
      _analyticsService.logSignIn();
    } on AuthError catch (error) {
      onAuthError(_formatErrorMessage(error));
    } finally {
      if (!isDisposed) {
        isBusy = false;
      }
    }
  }

  String _formatErrorMessage(AuthError error) {
    final internalMessage = (error.internalError as AuthError)?.message;
    final formatedInternalMessage =
        internalMessage == null ? '' : ': $internalMessage';
    return error.message + formatedInternalMessage;
  }
}
