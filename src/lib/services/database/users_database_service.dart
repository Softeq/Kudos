import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/dto/user_registration.dart';
import 'package:kudosapp/helpers/firestore_helpers.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/services/cache/item_change.dart';

class UsersDatabaseService {
  static const _usersCollection = "users";
  static const _pushTokenCollection = "push_tokens";

  final _database = FirebaseFirestore.instance;

  final _streamTransformer =
      StreamTransformer<QuerySnapshot, Iterable<ItemChange<User>>>.fromHandlers(
    handleData: (querySnapshot, sink) {
      var usersChanges = querySnapshot.docChanges.map(
        (dc) => ItemChange<User>(
          User.fromJson(dc.doc.data(), dc.doc.id),
          dc.type.toItemChangeType(),
        ),
      );

      sink.add(usersChanges);
    },
  );

  Query _getUsersQuery() {
    return _database.collection(_usersCollection);
  }

  Stream<Iterable<ItemChange<User>>> getUsersStream() {
    return _getUsersQuery().snapshots().transform(_streamTransformer);
  }

  Future<Iterable<User>> getUsers() async {
    return _getUsersQuery()
        .get()
        .then((value) => value.docs.map((d) => User.fromJson(d.data(), d.id)));
  }

  Future<void> registerUser(
    String userId,
    UserRegistration userRegistration,
    String pushToken,
  ) async {
    await _database
        .collection(_usersCollection)
        .doc(userId)
        .set(userRegistration.toJson(), SetOptions(merge: true));

    if (pushToken != null) {
      await _database
          .collection(_usersCollection)
          .doc(userId)
          .collection(_pushTokenCollection)
          .add({"token": pushToken});
    }
  }

  Future<void> incrementReceivedAchievementsCount(String userId,
      {WriteBatch batch}) async {
    var docRef = _database.collection(_usersCollection).doc(userId);

    if (batch != null) {
      batch.update(
        docRef,
        {
          "received_achievements_count": FieldValue.increment(1),
        },
      );
    } else {
      return docRef.update({
        "received_achievements_count": FieldValue.increment(1),
      });
    }
  }

  Future<void> updateOrdering(UserModel userModel) {
    return _database.collection(_usersCollection).doc(userModel.id).set(
        {"achievements_ordering": userModel.achievementsOrdering},
        SetOptions(merge: true));
  }
}
