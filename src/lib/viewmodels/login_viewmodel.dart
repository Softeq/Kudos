import 'package:kudosapp/helpers/disposable.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class LoginViewModel extends BaseViewModel with Disposable {
  final AuthViewModel _authViewModel;

  LoginViewModel(this._authViewModel);

  Future<void> signIn() async {
    isBusy = true;
    try {
      await _authViewModel.signIn();
    } finally {
      if (!isDisposed) {
        isBusy = false;
      }
    }
  }
}
