import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/user_model.dart';

/// [User] model that used for update user profile after auth.
/// Users collection
@immutable
class UserRegistration {
  final String name;
  final String email;
  final String imageUrl;

  UserRegistration._({
    @required this.name,
    @required this.email,
    @required this.imageUrl,
  });

  factory UserRegistration.fromModel(UserModel model) {
    return UserRegistration._(
      name: model.name,
      email: model.email,
      imageUrl: _getOriginalImageUrl(model.imageUrl),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "image_url": imageUrl,
    };
  }

  static String _getOriginalImageUrl(String imageUrl) {
    // remove default image size parameter
    return imageUrl.replaceAll("=s96-c", "");
  }
}
