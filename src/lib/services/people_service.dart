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
    final users = queryResult.documents
      .map<User>((x) => User(
        id: x.documentID,
        name: x.data["name"],
        email: x.data["email"],
        photoUrl: 'https://picsum.photos/50?random=${x.hashCode}' // TODO YP: need real photos
      ))
      .where((User x) => x.email != authService.currentUser.email)
      .toList();

    return users;
  }
}