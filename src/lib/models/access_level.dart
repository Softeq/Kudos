enum AccessLevel {
  official, // 0
  public, // 1
  protected, // 2
  private, // 3
}

extension AccessLevelExt on AccessLevel {
  static List<AccessLevel> getVisibleAccessLevels() => [
        AccessLevel.public,
        AccessLevel.protected,
        AccessLevel.private,
      ];

  bool get canBeViewed =>
      this == AccessLevel.official ||
      this == AccessLevel.public ||
      this == AccessLevel.protected;

  bool get canBeSent =>
      this == AccessLevel.official || this == AccessLevel.public;
}
