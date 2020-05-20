import 'package:kudosapp/helpers/disposable.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class ProfileViewModel extends BaseViewModel with Disposable {
  final PeopleService _peopleService = locator<PeopleService>();
  final String _userId;

  User _user;

  ProfileViewModel(this._userId);

  User get user => _user;

  Future<void> initialize() async {
    final user = await _peopleService.getUserById(_userId);
    _user = user;
    if (!isDisposed) {
      notifyListeners();
    }
  }
}
