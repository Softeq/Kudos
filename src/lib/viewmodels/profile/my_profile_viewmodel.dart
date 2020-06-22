import 'package:flutter/cupertino.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_teams_viewmodel.dart';

class MyProfileViewModel extends BaseViewModel {
  final myTeamsViewModel = MyTeamsViewModel();
  final _peopleService = locator<PeopleService>();
  final _authService = locator<BaseAuthService>();
  final _dialogService = locator<DialogService>();

  User get user => _authService.currentUser;

  @override
  void dispose() {
    myTeamsViewModel.dispose();
    super.dispose();
  }

  Future<void> signOut(BuildContext context) async {
    if (await _dialogService.showTwoButtonsDialog(
        context: context,
        title: localizer().signOutConfirmationTitle,
        content: localizer().signOutConfirmationMessage,
        firstButtonTitle: localizer().signOutConfirmButton,
        secondButtonTitle: localizer().signOutCancelButton,
        firstButtonColor: KudosTheme.destructiveButtonColor)) {
      await _peopleService.unsubscribeFromNotifications();
      await _authService.signOut();
    }
  }
}
