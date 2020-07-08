import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/user_model.dart';

/// Teams collection -> team_members array
@immutable
class TeamMember extends Equatable {
  final String id;
  final String name;

  TeamMember._(
    this.id,
    this.name,
  );

  factory TeamMember.fromModel(UserModel model) {
    return TeamMember._(
      model.id,
      model.name,
    );
  }

  factory TeamMember.fromDocument(DocumentSnapshot x) {
    return TeamMember._(
      x.documentID,
      x.data["name"],
    );
  }

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember._(
      map["id"],
      map["name"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  List<Object> get props => [id];
}
