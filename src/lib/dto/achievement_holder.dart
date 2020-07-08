import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/dto/user_reference.dart';
import 'package:kudosapp/models/user_model.dart';

/// Achievement collection -> Holders subcollection
@immutable
class AchievementHolder extends Equatable {
  final DateTime date;
  final UserReference recipient;

  AchievementHolder._({
    @required this.date,
    @required this.recipient,
  });

  factory AchievementHolder.fromModel(UserModel model) {
    return AchievementHolder._(
      date: DateTime.now(),
      recipient: UserReference.fromModel(model),
    );
  }

  factory AchievementHolder.fromDocument(DocumentSnapshot x) {
    return AchievementHolder._(
      date: x.data["date"].toDate(),
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
