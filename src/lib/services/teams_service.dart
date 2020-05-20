import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/models/team_member.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class TeamsService {
  static const String _teamsCollection = "teams";
  static const String _membersCollection = "members";
  static const String _ownersCollection = "owners";

  final _database = Firestore.instance;
  final _authService = locator<BaseAuthService>();

  Future<Team> createTeam(String name, String description) async {
    if (name == null || name.isEmpty) {
      throw ArgumentError.notNull(name);
    }

    var firstMember = TeamMember.fromUser(_authService.currentUser);

    var docRef = await _database.collection(_teamsCollection).add(
          Team.createMap(
            name: name,
            description: description,
            members: [firstMember.id],
            owners: [firstMember.id],
          ),
        );

    await _database
        .collection(_teamsCollection)
        .document(docRef.documentID)
        .collection(_membersCollection)
        .document(firstMember.id)
        .setData(firstMember.toMap());

    await _database
        .collection(_teamsCollection)
        .document(docRef.documentID)
        .collection(_ownersCollection)
        .document(firstMember.id)
        .setData(firstMember.toMap());

    var document = await docRef.get();
    return Team.fromDocument(document, [firstMember], [firstMember]);
  }

  Future<void> editTeam(String id, String name, String description) async {
    if (name == null || name.isEmpty) {
      throw ArgumentError.notNull(name);
    }

    await _database.collection(_teamsCollection).document(id).setData(
        Team.createMap(
          name: name,
          description: description,
        ),
        merge: true);
  }

  Future<List<Team>> getTeams([String id]) async {
    var userId = id;
    if (userId == null) {
      userId = _authService.currentUser.id;
    }

    //TODO VPY: find better method
    var result = await _getTeams(_ownersCollection, userId);
    var members = await _getTeams(_membersCollection, userId);

    members.forEach((x) {
      var team = result.firstWhere((y) => y.id == x.id, orElse: () => null);
      if (team == null) {
        result.add(x);
      }
    });

    return result;
  }

  Future<Team> getTeam(String id) async {
    var docRef = _database.collection(_teamsCollection).document(id);
    var document = await docRef.get();
    var ownersSnap = await docRef.collection(_ownersCollection).getDocuments();
    var owners =
        ownersSnap.documents.map((x) => TeamMember.fromDocument(x)).toList();
    var membersSnap =
        await docRef.collection(_membersCollection).getDocuments();
    var members =
        membersSnap.documents.map((x) => TeamMember.fromDocument(x)).toList();
    return Team.fromDocument(document, owners, members);
  }

  Future<void> updateTeamMembers(String id, List<TeamMember> newMembers) async {
    return _updateUsers(id, _membersCollection, newMembers);
  }

  Future<void> updateAdmins(String id, List<TeamMember> newMembers) {
    return _updateUsers(id, _ownersCollection, newMembers);
  }

  Future<void> _updateUsers(
    String id,
    String collectionName,
    List<TeamMember> newUsers,
  ) async {
    var collectionRef = _database
        .collection(_teamsCollection)
        .document(id)
        .collection(collectionName);
    var querySnapshot = await collectionRef.getDocuments();
    var oldUsers = querySnapshot.documents;

    var oldIds = oldUsers.map((x) => x.documentID).toList();
    var newIds = newUsers.map((x) => x.id).toList();
    var idsToDelete = oldIds.where((x) => !newIds.contains(x)).toList();

    var batch = _database.batch();

    //delete
    idsToDelete.forEach((x) {
      batch.delete(collectionRef.document(x));
    });

    //insert
    newUsers.forEach((x) {
      if (!oldIds.contains(x.id)) {
        batch.setData(collectionRef.document(x.id), x.toMap());
      }
    });

    await _database.collection(_teamsCollection).document(id).setData(
      {
        collectionName: newUsers.map((x) => x.id).toList(),
      },
      merge: true,
    );

    await batch.commit();
  }

  Future<List<Team>> _getTeams(String field, String userId) async {
    var qs = await _database
        .collection(_teamsCollection)
        .where(field, arrayContains: userId)
        .getDocuments();
    return qs.documents.map((x) => Team.fromDocument(x, null, null)).toList();
  }
}
