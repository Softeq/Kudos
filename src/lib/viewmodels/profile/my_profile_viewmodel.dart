import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_teams_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';

class MyProfileViewModel extends BaseViewModel {
  final AuthViewModel auth;
  final ProfileViewModel profile;
  final myAchievementsViewModel = MyAchievementsViewModel();
  final myTeamsViewModel = MyTeamsViewModel();

  MyProfileViewModel(this.auth, this.profile);

  @override
  void dispose() {
    myAchievementsViewModel.dispose();
    myTeamsViewModel.dispose();
    super.dispose();
  }
}
