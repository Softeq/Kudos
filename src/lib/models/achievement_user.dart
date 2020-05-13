import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/user.dart';

class AchievementUser {
  final Timestamp date;
  final User recipient;

  AchievementUser._({@required this.date, @required this.recipient});

  factory AchievementUser.fromDocument(DocumentSnapshot x) {
    return AchievementUser._(
      date: x.data["date"],
      recipient: User.fromMap(x.data["recipient"]),
    );
  }
}
