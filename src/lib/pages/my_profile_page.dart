import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/viewmodels/my_profile_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/profile_achievement_list_widget.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProfileViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 4.0),
            _buildTopBar(context, viewModel),
            SizedBox(height: 4.0),
            Expanded(
              child: TopDecorator.buildLayoutWithDecorator(
                Container(
                  color: KudosTheme.contentColor,
                  child: ProfileAchievementsListWidget(
                    viewModel.user.id,
                    false,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, MyProfileViewModel viewModel) {
    return Row(
      children: <Widget>[
        SizedBox(width: 16.0),
        ClipOval(
          child: Container(
            color: KudosTheme.contentColor,
            height: 38.0,
            width: 38.0,
            child: Center(
              child: Container(
                height: 34.0,
                width: 34.0,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: CachedNetworkImageProvider(
                    viewModel.user.imageUrl,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                viewModel.user.name,
                style: KudosTheme.userNameTitleTextStyle,
              ),
              SizedBox(height: 4.0),
              Text(
                viewModel.user.email,
                style: KudosTheme.userNameSubTitleTextStyle,
              ),
            ],
          ),
        ),
        IconButton(
          icon: SvgPicture.asset("assets/icons/exit.svg"),
          onPressed: () => viewModel.signOut(context),
        ),
      ],
    );
  }
}
