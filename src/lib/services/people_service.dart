import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/models/user_registration.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class PeopleService {
  final Firestore _database = Firestore.instance;
  final BaseAuthService _authService = locator<BaseAuthService>();
  static const _usersCollection = "users";

  //getting all users from firebase
  Future<List<User>> getAllUsers() {
    return _getAllUsers();
  }

  //getting all users from firebase
  Future<List<User>> getAllowedUsers() async {
    final allUsers = await _getAllUsers();
    final currentUserId = _authService.currentUser.id;
    final users = allUsers.where((x) => x.id != currentUserId).toList();
    return users;
  }

  Future<void> tryRegisterUser(User user) async {
    final userRegistrationMap = UserRegistration.fromUser(user).toMap();
    await _database
        .collection(_usersCollection)
        .document(user.id)
        .setData(userRegistrationMap);
  }

  //getting all users from firebase
  Future<List<User>> find(String request, bool _allowCurrentUser) async {
    final allUsers = await _getAllUsers();
    final userFilter = _UserFilter(
      _authService.currentUser.id,
      _allowCurrentUser,
      request,
    );
    final users = allUsers.where((x) => userFilter._filter(x)).toList();
    return users;
  }

  Future<List<User>> getUsersByIds(List<String> userIds) async {
    final qs = await _database
        .collection(_usersCollection)
        .where(FieldPath.documentId, whereIn: userIds)
        .getDocuments();
    final users = qs.documents.map<User>((x) => User.fromDocument(x)).toList();
    return users;
  }

  Future<User> getUserById(String userId) async {
    var queryResult =
        await _database.collection(_usersCollection).document(userId).get();
    if (queryResult.data == null) {
      throw ("User not found");
    }
    return User.fromDocument(queryResult);
  }

  Future<List<User>> _getAllUsers() async {
    final queryResult = await _database
        .collection(_usersCollection)
        .orderBy("name")
        .getDocuments();
    final users =
        queryResult.documents.map<User>((x) => User.fromDocument(x)).toList();
    return users;
  }
}

class _UserFilter {
  final String _currentUserId;
  final bool _allowCurrentUser;
  final String _request;

  _UserFilter(this._currentUserId, this._allowCurrentUser, this._request);

  bool _filter(User x) {
    if (_allowCurrentUser == false && x.id == _currentUserId) {
      return false;
    }

    if (!x.name.toLowerCase().contains(_request.toLowerCase())) {
      return false;
    }

    return true;
  }
}
