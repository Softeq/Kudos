import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/snack_bar_notifier_service.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/profile_achievement_list_widget.dart';
import 'package:kudosapp/widgets/common/fancy_list_widget.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/section_header_widget.dart';
import 'package:kudosapp/widgets/sliver_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class ProfileRoute extends MaterialPageRoute {
  ProfileRoute(UserModel userModel)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<ProfileViewModel>(
              create: (context) => ProfileViewModel(userModel),
              child: ProfilePage(),
            );
          },
        );
}

class ProfilePage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _snackBarNotifier = locator<SnackBarNotifierService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return CustomScrollView(
            slivers: _buildSlivers(context, viewModel).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: KudosTheme.sendIcon,
        onPressed: () => _sendTapped(context),
      ),
    );
  }

  void _sendTapped(BuildContext context) async {
    try {
      var viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      await viewModel.sendAchievement(context);
    } catch (error) {
      _snackBarNotifier.showGeneralErrorMessage(
          _scaffoldKey.currentContext, _scaffoldKey.currentState);
    }
  }

  Widget _addDefaultSliverPadding(Widget widget) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 16, right: 16),
      sliver: widget,
    );
  }

  Iterable<Widget> _buildSlivers(
      BuildContext context, ProfileViewModel viewModel) sync* {
    yield SliverGradientAppBar(
      title: viewModel.userName,
      imageWidget: _buildAppBarImage(
        context,
        viewModel.imageUrl,
        viewModel.userName,
      ),
      heroTag: viewModel.imageUrl,
    );

    if (viewModel.user == null) {
      yield SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      yield _addDefaultSliverPadding(
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16),
              SectionHeaderWidget(localizer().teams),
              SizedBox(height: 10),
              FancyListWidget<TeamModel>(
                viewModel.userTeams,
                (team) => team.name,
                localizer().userTeamsEmptyPlaceholder,
              ),
              SizedBox(height: 30),
              SectionHeaderWidget(localizer().achievements),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
      yield _addDefaultSliverPadding(
        ProfileAchievementsListWidget(viewModel.user.id, true, false),
      );
    }
  }

  Widget _buildAppBarImage(
      BuildContext context, String imageUrl, String userName) {
    return Center(
      child: RoundedImageWidget.square(
        imageUrl: imageUrl,
        size: MediaQuery.of(context).size.width,
        borderRadius: 0,
        title: userName,
      ),
    );
  }
}
