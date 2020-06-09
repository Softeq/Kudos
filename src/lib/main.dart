import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/kudos_app.dart';
import 'package:kudosapp/service_locator.dart';

void main() {
  setupLocator();

  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(KudosApp());
}
