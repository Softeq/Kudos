import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_teams_viewmodel.dart';

class MyProfileViewModel extends BaseViewModel {
  final myAchievementsViewModel = MyAchievementsViewModel();
  final myTeamsViewModel = MyTeamsViewModel();

  final _authService = locator<BaseAuthService>();

  User get user => _authService.currentUser;

  @override
  void dispose() {
    myAchievementsViewModel.dispose();
    myTeamsViewModel.dispose();
    super.dispose();
  }

  void signOut() {
    _authService.signOut();
  }
}
