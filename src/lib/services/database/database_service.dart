import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _database = Firestore.instance;

  Future<void> batchUpdate(
    Function(WriteBatch) f1,
    Function(WriteBatch) f2,
  ) {
    var batch = _database.batch();

    f1.call(batch);
    f2.call(batch);

    return batch.commit();
  }
}
