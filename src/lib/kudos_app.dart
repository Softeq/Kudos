import 'package:flutter/material.dart';
import 'package:kudosapp/pages/home_page.dart';
import 'package:kudosapp/services/localization_service.dart';

class KudosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LocalizationService.appName,
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}
