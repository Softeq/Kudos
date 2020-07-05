import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/dto/user_registration.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/push_notifications_service.dart';

class PeopleService {
  static const _usersCollection = "users";
  static const _pushTokenCollection = "push_tokens";

  final _database = Firestore.instance;
  final _authService = locator<BaseAuthService>();
  final _pushNotificationsService = locator<PushNotificationsService>();
  final _cachedUsers = List<UserModel>();

  PeopleService() {
    _database.collection(_usersCollection).snapshots().listen((s) {
      final users = s.documents
          .map<UserModel>((x) => UserModel.fromUser(User.fromDocument(x)))
          .toList();
      users.sort((x, y) => x.name.compareTo(y.name));

      _cachedUsers.clear();
      _cachedUsers.addAll(users);
    });
  }

  Future<int> getUsersCount() {
    return Future.value(_cachedUsers.length);
  }

  Future<List<UserModel>> getAllUsers() {
    return _getAllUsers();
  }

  Future<void> tryRegisterCurrentUser() async {
    final user = _authService.currentUser;
    final userRegistrationMap = UserRegistration.fromUser(user).toMap();
    final token = await _pushNotificationsService.subscribeForNotifications();
    await _database
        .collection(_usersCollection)
        .document(user.id)
        .setData(userRegistrationMap, merge: true);

    if (token == null) {
      return;
    }

    await _database
        .collection(_usersCollection)
        .document(user.id)
        .collection(_pushTokenCollection)
        .add({"token": token});
  }

  Future<void> unsubscribeFromNotifications() {
    return _pushNotificationsService.unSubscribeFromNotifications();
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

  Future<List<UserModel>> _getAllUsers() {
    return Future.value(_cachedUsers);
  }
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
