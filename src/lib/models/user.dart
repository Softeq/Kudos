import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String photoUrl;

  User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.photoUrl,
  });
}