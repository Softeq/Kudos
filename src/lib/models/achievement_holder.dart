import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/related_user.dart';

class AchievementHolder {
  final Timestamp date;
  final RelatedUser recipient;

  AchievementHolder({
    @required this.date,
    @required this.recipient,
  });

  factory AchievementHolder.fromDocument(DocumentSnapshot x) {
    return AchievementHolder(
      date: x.data["date"],
      recipient: RelatedUser.fromMap(x.data["recipient"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "recipient": recipient.toMap(),
    };
  }
}