import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/dto/user_registration.dart';

class UsersDatabaseService {
  static const _usersCollection = "users";
  static const _pushTokenCollection = "push_tokens";

  final _database = Firestore.instance;

  Stream<List<User>> getUsersStream() {
    return _database.collection(_usersCollection).snapshots().transform(
        StreamTransformer<QuerySnapshot, List<User>>.fromHandlers(
            handleData: (query, sink) {
      final users = query.documents
          .map<User>((d) => User.fromJson(d.data, d.documentID))
          .toList();
      sink.add(users);
    }));
  }

  Future<void> registerUser(
      String userId, UserRegistration userRegistration, String pushToken) {
    return _database
        .collection(_usersCollection)
        .document(userId)
        .setData(userRegistration.toJson(), merge: true)
        .whenComplete(() => {
              if (pushToken != null)
                {
                  _database
                      .collection(_usersCollection)
                      .document(userId)
                      .collection(_pushTokenCollection)
                      .add({"token": pushToken})
                }
            });
  }
}
