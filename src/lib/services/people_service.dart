import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class PeopleService {
  final Firestore database = Firestore.instance;
  final BaseAuthService authService = locator<BaseAuthService>();

  Future<List<User>> getAllUsers() async {
    final queryResult = await database.collection("users").getDocuments();
    final users = queryResult.documents
      .map<User>((x) => User(
        x.data["name"],
        x.data["email"],
        'https://picsum.photos/50' // TODO YP: need real photos
      ))
      .where((User x) => x.email != authService.currentUser.email)
      .toList();
    return users;
  }
}