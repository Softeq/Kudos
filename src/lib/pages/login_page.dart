import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/snack_bar_notifier_service.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/viewmodels/login_viewmodel.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final _snackBarNotifier = locator<SnackBarNotifierService>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AuthViewModel, LoginViewModel>(
      create: (context) => null,
      update: (context, authViewModel, _) {
        return LoginViewModel(authViewModel);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GradientAppBar(title: localizer().appName),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                localizer().notSignedIn,
                style: KudosTheme.screenStateTitleTextStyle,
              ),
              Image(
                image: AssetImage('assets/icons/prize.png'),
                width: 200,
                color: KudosTheme.mainGradientStartColor,
              ),
              Container(
                height: 100,
                alignment: Alignment.center,
                child: viewModel.isBusy
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        color: KudosTheme.accentColor,
                        child: Text(
                          localizer().signIn,
                          style: KudosTheme.raisedButtonTextStyle,
                        ),
                        onPressed: () async =>
                            await viewModel.signIn(_onAuthError),
                      ),
              )
            ],
          );
        },
      ),
    );
  }

  void _onAuthError(String message) {
    _snackBarNotifier.showErrorMessage(
        _scaffoldKey.currentContext, _scaffoldKey.currentState, message);
  }
}
