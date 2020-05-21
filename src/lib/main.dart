import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/generated/codegen_loader.g.dart';
import 'package:kudosapp/kudos_app.dart';
import 'package:kudosapp/service_locator.dart';

void main() {
  setupLocator();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
      ],
      fallbackLocale: Locale('en', 'US'),
      useOnlyLangCode: true,
      path: 'assets/translations',
      assetLoader: CodegenLoader(),
      child: KudosApp(),
    ),
  );
}
