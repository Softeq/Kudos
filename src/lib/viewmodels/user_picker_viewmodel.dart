import 'dart:async';

import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/queue_handler.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class UserPickerViewModel extends BaseViewModel {
  final _peopleService = locator<PeopleService>();
  final _users = List<User>();
  final _selectedUsers = List<User>();

  bool _allowCurrentUser;
  bool _searchPerformed;

  QueueHandler<List<User>, String> _searchQueueHandler;
  StreamSubscription<List<User>> _searchStreamSubscription;

  List<User> get users => _users;

  List<User> get selectedUsers => _selectedUsers;

  Future<void> initialize(
    List<String> selectedUserIds,
    bool allowCurrentUser,
  ) async {
    _allowCurrentUser = allowCurrentUser;
    _searchPerformed = false;
    _searchQueueHandler = QueueHandler<List<User>, String>(_findPeople);
    _searchStreamSubscription =
        _searchQueueHandler.responseStream.listen(_updateSearchResults);
    if (selectedUserIds != null && selectedUserIds.isNotEmpty) {
      var users = await _peopleService.getUsersByIds(selectedUserIds);
      _selectedUsers.addAll(users);
    }
    requestSearch("");
  }

  void requestSearch(String x) {
    _searchPerformed = true;
    _searchQueueHandler.addRequest(x);
  }

  bool isUserSelected(User x) {
    return _selectedUsers.contains(x);
  }

  void toggleUserSelection(User x) {
    isUserSelected(x) ? _selectedUsers.remove(x) : _selectedUsers.add(x);
    notifyListeners();
  }

  Future<List<User>> _findPeople(String request) async {
    var result = await _peopleService.find(request, _allowCurrentUser);
    if (_selectedUsers.isNotEmpty) {
      var addedIds = _selectedUsers.map((x) => x.id);
      result.sort((x, y) {
        var xSelected = addedIds.contains(x.id);
        var ySelected = addedIds.contains(y.id);
        return xSelected == ySelected
            ? x.name.compareTo(y.name)
            : (xSelected ? -1 : 1);
      });
    }

    return result;
  }

  void _updateSearchResults(List<User> users) {
    if (!_searchPerformed) {
      return;
    }
    _searchPerformed = false;

    _users.clear();
    _users.addAll(users);

    notifyListeners();
  }

  @override
  void dispose() {
    _searchQueueHandler.close();
    _searchStreamSubscription.cancel();
    super.dispose();
  }
}
