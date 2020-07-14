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

  factory AchievementHolder.fromJson(Map<String, dynamic> map) {
    return map == null
        ? null
        : AchievementHolder._(
            date: map["date"].toDate(),
            recipient: UserReference.fromJson(map["recipient"], null),
          );
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "recipient": recipient.toJson(),
    };
  }

  @override
  List<Object> get props => [recipient?.id];
}
