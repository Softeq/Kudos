import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/viewmodels/profile/my_profile_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/profile_achievement_list_widget.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MyProfileViewModel>(context, listen: false);
    final user = viewModel.user;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 5.0),
              _buildTopBar(context, viewModel),
              SizedBox(height: 12.0),
              Expanded(
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    Positioned.fill(
                      top: -.5,
                      child: Container(
                        color: KudosTheme.contentColor,
                        child: ProfileAchievementsListWidget(
                          user.id,
                          false,
                        ),
                      ),
                    ),
                    Positioned.directional(
                        textDirection: TextDirection.ltr,
                        top: 0,
                        child: TopDecorator(constraints.maxWidth)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, MyProfileViewModel viewModel) {
    return Row(
      children: <Widget>[
        SizedBox(width: 16.0),
        ClipOval(
          child: Container(
            color: KudosTheme.contentColor,
            height: 40.0,
            width: 40.0,
            child: Center(
              child: Container(
                height: 36.0,
                width: 36.0,
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
