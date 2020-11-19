import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/access_level.dart';
import 'package:kudosapp/service_locator.dart';

extension AccessLevelLocalizer on AccessLevel {
  String get title {
    switch (this) {
      case AccessLevel.official:
        return localizer().official;
      case AccessLevel.public:
        return localizer().accessLevelPublic;
      case AccessLevel.private:
        return localizer().accessLevelPrivate;
      case AccessLevel.protected:
        return localizer().accessLevelProtected;
      default:
        return null;
    }
  }

  String get description {
    switch (this) {
      case AccessLevel.official:
        return localizer().official;
      case AccessLevel.public:
        return localizer().accessLevelPublicDescription;
      case AccessLevel.private:
        return localizer().accessLevelPrivateDescription;
      case AccessLevel.protected:
        return localizer().accessLevelProtectedDescription;
      default:
        return null;
    }
  }
}

extension AccessLevelIcon on AccessLevel {
  IconData get icon {
    switch (this) {
      case AccessLevel.official:
        return Icons.public;
      case AccessLevel.public:
        return Icons.lock_open;
      case AccessLevel.private:
        return Icons.lock;
      case AccessLevel.protected:
        return Icons.lock_outline;
      default:
        return null;
    }
  }
}
