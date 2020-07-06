import 'package:kudosapp/viewmodels/base_viewmodel.dart';

/// Helper mixin to abstract away the `isImageLoading` logic.
mixin ImageLoading on BaseViewModel {
  bool _isImageLoading = false;

  bool get isImageLoading => _isImageLoading;
  set isImageLoading(bool value) {
    if (_isImageLoading != value) {
      _isImageLoading = value;
      notifyListeners();
    }
  }
}
