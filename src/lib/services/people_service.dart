import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/models/user_registration.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class PeopleService {
  final Firestore _database = Firestore.instance;
  final BaseAuthService _authService = locator<BaseAuthService>();
  static const _usersCollection = "users";

  Future<List<User>> getAllUsers() async {
    final query = _database.collection(_usersCollection).orderBy("name");
    final queryResult = await query.getDocuments();
    final users =
        queryResult.documents.map<User>((x) => User.fromDocument(x)).toList();
    return users;
  }

  Future<List<User>> getAllowedUsers() async {
    final query = _database.collection(_usersCollection).orderBy("name");
    final queryResult = await query.getDocuments();
    final users = queryResult.documents
        .map<User>((x) => User.fromDocument(x))
        .where((User x) => x.email != _authService.currentUser.email)
        .toList();
    return users;
  }

  Future<void> tryRegisterUser(User user) async {
    final query = _database.collection(_usersCollection).document(user.id);
    final userRegistrationMap = UserRegistration.fromUser(user).toMap();
    await query.setData(userRegistrationMap);
  }

  Future<List<User>> find(String request) async {
    //TODO VPY: we should cache all users if it possible to reduce query result
    final query = _database.collection(_usersCollection).orderBy("name");
    final queryResult = await query.getDocuments();
    final users = queryResult.documents
        .map<User>((x) => User.fromDocument(x))
        .where((User x) => x.name.toLowerCase().contains(request.toLowerCase()))
        .toList();
    return users;
  }

  Future<List<User>> getUsersByIds(List<String> userIds) async {
    var qs = await _database
        .collection(_usersCollection)
        .where(FieldPath.documentId, whereIn: userIds)
        .getDocuments();
    var users = qs.documents.map<User>((x) => User.fromDocument(x)).toList();
    return users;
  }
}
