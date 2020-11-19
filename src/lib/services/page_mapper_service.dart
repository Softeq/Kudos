import 'package:flutter/widgets.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/achievements/achievements_page.dart';
import 'package:kudosapp/pages/achievements/edit_achievement_page.dart';
import 'package:kudosapp/pages/achievements/received_achievement_page.dart';
import 'package:kudosapp/pages/login_page.dart';
import 'package:kudosapp/pages/mandatory_update_page.dart';
import 'package:kudosapp/pages/my_profile_page.dart';
import 'package:kudosapp/pages/users/user_details_page.dart';
import 'package:kudosapp/pages/teams/team_member_picker_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/teams/team_details_page.dart';
import 'package:kudosapp/pages/teams/teams_page.dart';
import 'package:kudosapp/pages/users/users_page.dart';
import 'package:kudosapp/viewmodels/achievements/achievement_details_viewmodel.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/achievements/edit_achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/login_viewmodel.dart';
import 'package:kudosapp/viewmodels/mandatory_update_viewmodel.dart';
import 'package:kudosapp/viewmodels/my_profile_viewmodel.dart';
import 'package:kudosapp/viewmodels/users/received_achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/users/user_details_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/team_member_picker_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/edit_team_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/team_details_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/teams_viewmodel.dart';
import 'package:kudosapp/viewmodels/users/users_viewmodel.dart';

class PageMapperService {
  Widget getPage<T>() {
    switch (T) {
      case LoginViewModel:
        return LoginPage();

      case MyProfileViewModel:
        return MyProfilePage();

      case MandatoryUpdateViewModel:
        return MandatoryUpdatePage();

      case AchievementsViewModel:
        return AchievementsPage();
      case AchievementDetailsViewModel:
        return AchievementDetailsPage();
      case EditAchievementViewModel:
        return EditAchievementPage();
      case ReceivedAchievementViewModel:
        return ReceivedAchievementPage();

      case TeamsViewModel:
        return TeamsPage();
      case TeamDetailsViewModel:
        return TeamDetailsPage();
      case EditTeamViewModel:
        return EditTeamPage();
      case TeamMemberPickerViewModel:
        return TeamMemberPickerPage();

      case UsersViewModel:
        return UsersPage();
      case UserDetailsViewModel:
        return UserDetailsPage();
    }
    return null;
  }

  String getPageName<T>() {
    switch (T) {
      case LoginViewModel:
        return "Login";

      case MyProfileViewModel:
        return "My Profile";

      case MandatoryUpdateViewModel:
        return "Mandatory Update";

      case AchievementsViewModel:
        return "Achievements List";
      case AchievementDetailsViewModel:
        return "Achievement Details";
      case EditAchievementViewModel:
        return "Edit Achievement";
      case ReceivedAchievementViewModel:
        return "Received Achievement";

      case TeamsViewModel:
        return "Teams List";
      case TeamDetailsViewModel:
        return "Team Details";
      case EditTeamViewModel:
        return "Edit Team";
      case TeamMemberPickerViewModel:
        return "Team Member Picker";

      case UsersViewModel:
        return "Users List";
      case UserDetailsViewModel:
        return "User Details";
    }
    return null;
  }

  Widget getTab<T>() {
    switch (T) {
      case MyProfileViewModel:
        return MyProfilePage();
      case TeamsViewModel:
        return TeamsTab();
      case UsersViewModel:
        return UsersTab();
      case AchievementsViewModel:
        return AchievementsTab();
    }

    return null;
  }

  String getTabName<T>() {
    switch (T) {
      case MyProfileViewModel:
        return "My Profile Tab";
      case TeamsViewModel:
        return "Teams Tab";
      case UsersViewModel:
        return "Users Tab";
      case AchievementsViewModel:
        return "Achievements Tab";
    }

    return null;
  }
}
