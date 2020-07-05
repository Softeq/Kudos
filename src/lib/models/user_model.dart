import 'package:kudosapp/dto/team_member.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/dto/user_reference.dart';

class UserModel {
  String id;
  String name;
  String imageUrl;
  String email;
  int receivedAchievementsCount;

  UserModel({
    this.id,
    this.name,
    this.imageUrl,
    this.email,
    this.receivedAchievementsCount,
  });

  factory UserModel.mock({int index = 0}) {
    return UserModel(
      id: "test_id #{$index}",
      name: "Test Name #$index",
      email: "test.name@softeq.com",
      imageUrl: "https://picsum.photos/200?random=$index",
      receivedAchievementsCount: 0,
    );
  }

  UserModel.fromUserReference(UserReference userReference) {
    id = userReference.id;
    name = userReference.name;
    imageUrl = userReference.imageUrl;
  }

  UserModel.fromTeamMember(TeamMember teamMember) {
    id = teamMember.id;
    name = teamMember.name;
  }

  UserModel.fromUser(User user) {
    _updateWithUser(user);
  }

  void _updateWithUser(User user) {
    id = user.id;
    name = user.name;
    imageUrl = user.imageUrl;
    email = user.email;
    receivedAchievementsCount = user.receivedAchievementsCount;
  }

  void updateWithModel(UserModel user) {
    id = user.id;
    name = user.name;
    imageUrl = user.imageUrl;
    email = user.email;
    receivedAchievementsCount = user.receivedAchievementsCount;
  }
}
