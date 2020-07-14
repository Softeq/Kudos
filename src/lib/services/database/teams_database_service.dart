import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/dto/team.dart';

class TeamsDatabaseService {
  static const _teamsCollection = "teams";

  final _database = Firestore.instance;

  Future<Iterable<Team>> getUserTeams(String userId) {
    return _database
        .collection(_teamsCollection)
        .where("visible_for", arrayContains: userId)
        .where("is_active", isEqualTo: true)
        .getDocuments()
        .then((value) => value.documents.map((e) => Team.fromDocument(e)));
  }

  Future<Team> getTeam(String teamId) {
    return _database
        .collection(_teamsCollection)
        .document(teamId)
        .get()
        .then((value) => Team.fromDocument(value));
  }

  Future<Team> createTeam(Team team) {
    return _database
        .collection(_teamsCollection)
        .add(team.toMap(all: true))
        .then((value) => value.get())
        .then((value) => Team.fromDocument(value));
  }

  Future<Team> updateTeam(
    Team team, {
    bool metadata = false,
    bool image = false,
    bool members = false,
    bool owners = false,
    bool isActive = false,
    WriteBatch batch,
  }) {
    final docRef = _database.collection(_teamsCollection).document(team.id);
    final map = team.toMap(
      all: false,
      metadata: metadata,
      image: image,
      members: members,
      owners: owners,
      isActive: isActive,
    );
    if (batch == null) {
      return docRef
          .setData(map, merge: true)
          .then((value) => docRef.get())
          .then((value) => Team.fromDocument(value));
    } else {
      batch.setData(docRef, map, merge: true);
      return null;
    }
  }

  Future<void> deleteTeam(String teamId) {
    return _database.collection(_teamsCollection).document(teamId).delete();
  }
}
