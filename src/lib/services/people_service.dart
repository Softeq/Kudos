import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class PeopleService {
  final Firestore database = Firestore.instance;
  final BaseAuthService authService = locator<BaseAuthService>();

  Future<List<User>> getAllUsers() async {
    final query = database.collection("users").orderBy("name");
    final queryResult = await query.getDocuments();
    final users =
        queryResult.documents.map<User>((x) => User.fromDocument(x)).toList();
    return users;
  }

  Future<List<User>> getAllowedUsers() async {
    final query = database.collection("users").orderBy("name");
    final queryResult = await query.getDocuments();
    final users = queryResult.documents
        .map<User>((x) => User.fromDocument(x))
        .where((User x) => x.email != authService.currentUser.email)
        .toList();
    return users;
  }

  Future<void> tryRegisterUser(User user) async {
    final query = database.collection("users").document(user.id);
    await query.setData(user.toMapForRegistration());
  }

  Future<List<User>> find(String request) async {
    final query = database.collection("users").orderBy("name");
    final queryResult = await query.getDocuments();
    final users = queryResult.documents
        .map<User>((x) => User.fromDocument(x))
        .where((User x) =>
            x.email != authService.currentUser.email &&
            x.name.toLowerCase().contains(request.toLowerCase()))
        .toList();
    return users;
  }
}
