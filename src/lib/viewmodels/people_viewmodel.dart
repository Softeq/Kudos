import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class PeopleViewModel extends BaseViewModel {
  final PeopleService _peopleService = locator<PeopleService>();
  final List<User> _people = [];

  Future<List<User>> get people async {
    if (_people.isEmpty) {
      var result = await _peopleService.getAllUsers();
      _people.addAll(result);
    }

    return [..._people];
  }
}