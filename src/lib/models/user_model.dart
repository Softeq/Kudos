import 'package:kudosapp/dto/team_member.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/dto/user_reference.dart';

class UserModel {
  String id;
  String name;
  String imageUrl;
  String email;
  int receivedAchievementsCount;

  UserModel._({
    this.id,
    this.name,
    this.imageUrl,
    this.email,
    this.receivedAchievementsCount,
  });

  factory UserModel.createNew(String name, String email, String imageUrl) {
    final id = email.split("@").first;
    return UserModel._(
      id: id,
      name: name,
      email: email,
      imageUrl: imageUrl,
      receivedAchievementsCount: 0,
    );
  }

  factory UserModel.mock({int index = 0}) {
    return UserModel._(
      id: "test_id #{$index}",
      name: "Test Name #$index",
      email: "test.name@softeq.com",
      imageUrl: "https://picsum.photos/200?random=$index",
      receivedAchievementsCount: 0,
    );
  }

  factory UserModel.fromUserReference(UserReference userReference) {
    return UserModel._(
      id: userReference.id,
      name: userReference.name,
      imageUrl: userReference.imageUrl,
    );
  }

  factory UserModel.fromTeamMember(TeamMember teamMember) {
    return UserModel._(
      id: teamMember.id,
      name: teamMember.name,
    );
  }

  factory UserModel.fromUser(User user) {
    return UserModel._(
      id: user.id,
      name: user.name,
      imageUrl: user.imageUrl,
      email: user.email,
      receivedAchievementsCount: user.receivedAchievementsCount,
    );
  }

  void updateWithModel(UserModel user) {
    id = user.id;
    name = user.name;
    imageUrl = user.imageUrl;
    email = user.email;
    receivedAchievementsCount = user.receivedAchievementsCount;
  }
}
