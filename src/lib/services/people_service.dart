import 'package:kudosapp/dto/user_registration.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/users_database_service.dart';
import 'package:kudosapp/services/push_notifications_service.dart';

class PeopleService {
  final _authService = locator<BaseAuthService>();
  final _pushNotificationsService = locator<PushNotificationsService>();
  final _usersDatabaseService = locator<UsersDatabaseService>();
  final _cachedUsers = List<UserModel>();

  PeopleService() {
    _usersDatabaseService.getUsersStream().listen((users) {
      users.sort((x, y) => x.name.compareTo(y.name));
      _cachedUsers.clear();
      _cachedUsers.addAll(users.map((u) => UserModel.fromUser(u)));
    });
  }

  Future<int> getUsersCount() => Future.value(_cachedUsers.length);

  Future<List<UserModel>> getAllUsers() => _getAllUsers();

  Future<void> tryRegisterCurrentUser() async {
    final user = _authService.currentUser;
    final token = await _pushNotificationsService.subscribeForNotifications();

    _usersDatabaseService.registerUser(
        user.id, UserRegistration.fromModel(user), token);
  }

  Future<void> unsubscribeFromNotifications() {
    return _pushNotificationsService.unsubscribeFromNotifications();
  }

  Future<List<UserModel>> find(String request, bool _allowCurrentUser) async {
    final allUsers = await _getAllUsers();
    final userFilter = _UserFilter(
      _authService.currentUser.id,
      _allowCurrentUser,
      request,
    );
    final users = allUsers.where((x) => userFilter._filter(x)).toList();
    return users;
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    final allUsers = await _getAllUsers();
    final users = allUsers.where((x) => userIds.contains(x.id)).toList();
    return users;
  }

  Future<UserModel> getUserById(String userId) async {
    final users = await _getAllUsers();
    final user = users.firstWhere((x) => x.id == userId, orElse: () => null);
    if (user == null) {
      throw ("User not found");
    }
    return user;
  }

  Future<List<UserModel>> _getAllUsers() => Future.value(_cachedUsers);
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
