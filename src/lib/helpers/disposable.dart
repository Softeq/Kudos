import 'package:kudosapp/viewmodels/base_viewmodel.dart';

/// Helper mixin to abstract away the `isDisposed` logic.
mixin Disposable on BaseViewModel {
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
