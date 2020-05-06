import 'package:flutter/material.dart';
import 'package:kudosapp/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/pages/home_page.dart';
import 'package:kudosapp/providers/auth.dart';
import 'package:kudosapp/services/localization_service.dart';

class KudosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, child) => MaterialApp(
          title: LocalizationService.appName,
          theme: ThemeData(),
          home: auth.isAuth
            ? HomePage()
            : LoginPage(),
        ),
      ),
    );
  }
}
