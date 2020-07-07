import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:kudosapp/helpers/queue_handler.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class UserPickerViewModel extends BaseViewModel {
  final _peopleService = locator<PeopleService>();
  final _dialogService = locator<DialogService>();

  final List<String> _selectedUserIds;
  final bool _allowCurrentUser;
  final bool _allowEmptyResult;

  final users = List<UserModel>();
  final selectedUsers = List<UserModel>();

  bool _searchPerformed;
  QueueHandler<List<UserModel>, String> _searchQueueHandler;
  StreamSubscription<List<UserModel>> _searchStreamSubscription;

  UserPickerViewModel(
      this._selectedUserIds, this._allowCurrentUser, this._allowEmptyResult) {
    _initialize();
  }

  void _initialize() async {
    _searchPerformed = false;
    _searchQueueHandler = QueueHandler<List<UserModel>, String>(_findPeople);
    _searchStreamSubscription =
        _searchQueueHandler.responseStream.listen(_updateSearchResults);
    if (_selectedUserIds != null && _selectedUserIds.isNotEmpty) {
      var users = await _peopleService.getUsersByIds(_selectedUserIds);
      selectedUsers.addAll(users);
    }
    requestSearch("");
  }

  void requestSearch(String x) {
    _searchPerformed = true;
    _searchQueueHandler.addRequest(x);
  }

  bool isUserSelected(UserModel x) {
    return selectedUsers.contains(x);
  }

  void toggleUserSelection(UserModel x) {
    isUserSelected(x) ? selectedUsers.remove(x) : selectedUsers.add(x);
    notifyListeners();
  }

  void trySaveResult(BuildContext context) {
    if (!_allowEmptyResult && selectedUsers.isEmpty) {
      _dialogService.showOkDialog(
          context: context,
          title: localizer().error,
          content: localizer().user_picker_empty_message);
      return;
    }

    Navigator.of(context).pop(selectedUsers);
  }

  Future<List<UserModel>> _findPeople(String request) async {
    var result = await _peopleService.find(request, _allowCurrentUser);
    if (selectedUsers.isNotEmpty) {
      var addedIds = selectedUsers.map((x) => x.id);
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

  void _updateSearchResults(List<UserModel> results) {
    if (!_searchPerformed) {
      return;
    }
    _searchPerformed = false;

    users.clear();
    users.addAll(results);

    notifyListeners();
  }

  @override
  void dispose() {
    _searchQueueHandler.close();
    _searchStreamSubscription.cancel();
    super.dispose();
  }
}
