import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class PeopleViewModel extends BaseViewModel {
  final PeopleService _peopleService = locator<PeopleService>();
  final List<User> _people = [];
  final bool excludeCurrentUser;

  PeopleViewModel({this.excludeCurrentUser});

  Future<List<User>> get people async {
    if (_people.isEmpty) {
      List<User> people = [];
      if (excludeCurrentUser == null) {
        people = await _peopleService.getAllUsers();
      } else {
        people = await _peopleService.getAllowedUsers();
      }
      _people.addAll(people);
    }

    return [..._people];
  }
}