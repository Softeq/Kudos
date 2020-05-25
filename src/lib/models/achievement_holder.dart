import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/user_reference.dart';

class AchievementHolder extends Equatable {
  final Timestamp date;
  final UserReference recipient;

  AchievementHolder({
    @required this.date,
    @required this.recipient,
  });

  factory AchievementHolder.fromDocument(DocumentSnapshot x) {
    return AchievementHolder(
      date: x.data["date"],
      recipient: UserReference.fromMap(x.data["recipient"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "recipient": recipient.toMap(),
    };
  }

  @override
  List<Object> get props => [recipient?.id];
}
