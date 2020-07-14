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
        .then((value) =>
            value.documents.map((d) => Team.fromJson(d.data, d.documentID)));
  }

  Future<Team> getTeam(String teamId) {
    return _database
        .collection(_teamsCollection)
        .document(teamId)
        .get()
        .then((value) => Team.fromJson(value.data, value.documentID));
  }

  Future<Team> createTeam(Team team) {
    return _database
        .collection(_teamsCollection)
        .add(team.toJson(all: true))
        .then((value) => value.get())
        .then((value) => Team.fromJson(value.data, value.documentID));
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
    final map = team.toJson(
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
          .then((value) => Team.fromJson(value.data, value.documentID));
    } else {
      batch.setData(docRef, map, merge: true);
      return null;
    }
  }

  Future<void> deleteTeam(String teamId) {
    return _database.collection(_teamsCollection).document(teamId).delete();
  }
}
