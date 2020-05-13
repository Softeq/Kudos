import 'dart:async';

import 'package:kudosapp/models/queue_handler.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class UserPickerViewModel extends BaseViewModel {
  final _peopleService = locator<PeopleService>();
  final _users = List<User>();
  final _selectedUsers = List<User>();

  QueueHandler<List<User>, String> _queueHandler;
  StreamSubscription<List<User>> _streamSubscription;
  UserPickerViewModelState _state = UserPickerViewModelState.initialState;

  UserPickerViewModelState get state => _state;

  List<User> get users => _users;

  List<User> get selectedUsers => _selectedUsers;

  void _setState(UserPickerViewModelState value) {
    _state = value;
    notifyListeners();
  }

  void initialize() {
    _queueHandler = QueueHandler<List<User>, String>(_findPeople);
    _streamSubscription =
        _queueHandler.responseStream.listen(_updateSearchResults);
  }

  void addToQueue(String x) {
    if (x.isEmpty) {
      if (_selectedUsers.isEmpty) {
        _setState(UserPickerViewModelState.initialState);
      } else {
        _setState(UserPickerViewModelState.selectedUsers);
      }
      return;
    }

    _state = UserPickerViewModelState.searchPerformed;
    _queueHandler.addRequest(x);
  }

  void select(User x) {
    _selectedUsers.add(x);
    _setState(UserPickerViewModelState.selectedUsers);
  }

  void unselect(User x) {
    _selectedUsers.remove(x);
    if (_selectedUsers.isEmpty) {
      _setState(UserPickerViewModelState.initialState);
    } else {
      _setState(UserPickerViewModelState.selectedUsers);
    }
  }

  Future<List<User>> _findPeople(String request) async {
    var result = await _peopleService.find(request);
    if (_selectedUsers.isNotEmpty) {
      var addedIds = _selectedUsers.map((x) => x.id);
      return result.where((x) => !addedIds.contains(x.id)).toList();
    }

    return result;
  }

  void _updateSearchResults(List<User> users) {
    if (state != UserPickerViewModelState.searchPerformed) {
      return;
    }

    _users.clear();
    _users.addAll(users);

    _setState(UserPickerViewModelState.searchResults);
  }

  @override
  void dispose() {
    _queueHandler.close();
    _streamSubscription.cancel();
    super.dispose();
  }
}

enum UserPickerViewModelState {
  initialState,
  searchPerformed,
  searchResults,
  selectedUsers,
}
