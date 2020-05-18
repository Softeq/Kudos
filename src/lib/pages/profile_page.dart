import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';

class ProfileRoute extends MaterialPageRoute {
  ProfileRoute(User user)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<ProfileViewModel>(
              create: (context) => ProfileViewModel(user),
              child: ProfilePage(),
            );
          },
        );
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return CustomScrollView(
            slivers: [
              _buildHeader(viewModel.user),
              ProfileAchievementsList(viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(User user) {
    return SliverAppBar(
      expandedHeight: 350.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(user.name),
        background: CachedNetworkImage(
          imageUrl: user.imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
