import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class MandatoryUpdateDatabaseService {
  final _database = FirebaseFirestore.instance;
  final _databaseVersion = 1;

  Stream<bool> get needUpdateAppStream {
    return _database
        .collection("config")
        .doc("database_version")
        .snapshots()
        .transform<bool>(
      StreamTransformer<DocumentSnapshot, bool>.fromHandlers(
        handleData: (ds, s) {
          final data = ds.data();
          final int version = data["version"];
          s.add(_databaseVersion < version);
        },
      ),
    );
  }
}
