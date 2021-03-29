import 'dart:async';

import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/dto/user_registration.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/cache/cached_data_service.dart';
import 'package:kudosapp/services/cache/item_change.dart';
import 'package:kudosapp/services/database/users_database_service.dart';

class UsersService extends CachedDataService<User, UserModel> {
  static const int InputStreamsCount = 1;

  final _authService = locator<BaseAuthService>();
  final _usersDatabaseService = locator<UsersDatabaseService>();

  UsersService() : super(InputStreamsCount);

  Future<List<UserModel>> getAllUsers() async {
    await loadData();
    return cachedData.values.toList();
  }

  Future<int> getUsersCount() async {
    await loadData();
    return cachedData.length;
  }

  Future<UserModel> getUser(String userId) async {
    await loadData();
    final user = cachedData[userId];
    if (user == null) {
      throw ("User not found");
    }
    return user;
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    await loadData();
    final users =
        cachedData.values.where((x) => userIds.contains(x.id)).toList();
    return users;
  }

  Future<void> tryRegisterCurrentUser(String pushToken) async {
    final user = _authService.currentUser;

    _usersDatabaseService.registerUser(
      user.id,
      UserRegistration.fromModel(user),
      pushToken,
    );
  }

  Future<List<UserModel>> find(String request, bool _allowCurrentUser) async {
    await loadData();
    final userFilter = _UserFilter(
      _authService.currentUser.id,
      _allowCurrentUser,
      request,
    );
    final users = cachedData.values.where((x) => userFilter._filter(x)).toList();
    return users;
  }

  Future<void> updateOrdering(UserModel userModel) {
    return _usersDatabaseService.updateOrdering(userModel);
  }

  @override
  UserModel convert(User item) {
    return UserModel.fromUser(item);
  }

  @override
  Future<Iterable<User>> getDataFromInputStream(int index) =>
      _usersDatabaseService.getUsers();

  @override
  String getItemId(UserModel item) => item.id;

  @override
  Stream<Iterable<ItemChange<User>>> getInputStream(int index) =>
      _usersDatabaseService.getUsersStream();
}

class _UserFilter {
  final String _currentUserId;
  final bool _allowCurrentUser;
  final String _request;

  _UserFilter(this._currentUserId, this._allowCurrentUser, this._request);

  bool _filter(UserModel x) {
    if (_allowCurrentUser == false && x.id == _currentUserId) {
      return false;
    }

    if (!x.name.toLowerCase().contains(_request.toLowerCase())) {
      return false;
    }

    return true;
  }
}
