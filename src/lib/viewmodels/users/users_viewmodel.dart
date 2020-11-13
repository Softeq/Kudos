import 'package:flutter/material.dart';
import 'package:kudosapp/models/selection_action.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/data_services/users_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/searchable_list_viewmodel.dart';
import 'package:kudosapp/viewmodels/users/user_details_viewmodel.dart';

class UsersViewModel extends SearchableListViewModel<UserModel> {
  final _peopleService = locator<UsersService>();
  final _navigationService = locator<NavigationService>();

  final Set<String> _excludedUserIds;
  final SelectionAction _selectionAction;
  final List<UserModel> _allowedMembers;

  final Icon selectorIcon;

  UsersViewModel(
    this._selectionAction, {
    Set<String> excludedUserIds,
    this.selectorIcon,
    List<UserModel> allowedMembers,
  })  : _excludedUserIds = excludedUserIds,
        _allowedMembers = allowedMembers,
        super(sortFunc: _sortFunc) {
    _initialize();
  }

  static int _sortFunc(UserModel x, UserModel y) {
    return y.name.toLowerCase().compareTo(y.name.toLowerCase());
  }

  void onItemClicked(BuildContext context, UserModel user) async {
    switch (_selectionAction) {
      case SelectionAction.OpenDetails:
        await _navigationService.navigateTo(
          UserDetailsViewModel(user),
        );
        updatePeopleList();
        break;
      case SelectionAction.Pop:
        _navigationService.pop(user);
        break;
    }
    clearFocus(context);
  }

  void _initialize() async {
    try {
      isBusy = true;

      if (_allowedMembers != null) {
        dataList.addAll(_allowedMembers);
      } else {
        final loadedUsers = await _peopleService.getAllUsers();
        dataList.addAll(loadedUsers);
      }

      if (_excludedUserIds != null && _excludedUserIds.isNotEmpty) {
        dataList.removeWhere((x) => _excludedUserIds.contains(x.id));
      }
    } finally {
      filterByName("");
      isBusy = false;
    }
  }

  void updatePeopleList() async {
    if (_excludedUserIds == null || _excludedUserIds.isEmpty) {
      notifyListeners();
    } else {
      try {
        isBusy = true;
        var loadedList = await _peopleService.getAllUsers();

        dataList.clear();
        dataList.addAll(loadedList);
        dataList.removeWhere((x) => _excludedUserIds.contains(x.id));
      } finally {
        isBusy = false;
      }
    }
  }

  @override
  bool filter(UserModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }
}
