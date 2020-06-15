import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/user.dart';

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

  factory UserRegistration.fromUser(User x) {
    return UserRegistration._(
      name: x.name,
      email: x.email,
      imageUrl: _getOriginalImageUrl(x.imageUrl),
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