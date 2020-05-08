import 'package:flutter/foundation.dart';

@immutable
class Achievement {
  final String description;
  final List<String> tags;
  final String name;
  final String imageUrl;
  final String id;

  Achievement({
    @required this.description,
    @required this.tags,
    @required this.name,
    @required this.imageUrl,
    @required this.id,
  });
}
