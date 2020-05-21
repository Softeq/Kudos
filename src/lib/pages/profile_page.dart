import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kudosapp/generated/locale_keys.g.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
import 'package:kudosapp/widgets/sliver_section_header_widget.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';

class ProfileRoute extends MaterialPageRoute {
  ProfileRoute(String userId)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<ProfileViewModel>(
              create: (context) => ProfileViewModel(userId)..initialize(),
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
            slivers: _buildSlivers(viewModel),
          );
        },
      ),
    );
  }

  List<Widget> _buildSlivers(ProfileViewModel viewModel) {
    if (viewModel.user == null) {
      return [
        SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ];
    }

    return [
      _buildHeader(viewModel.user),
      SliverSectionHeaderWidget(
        title: LocaleKeys.allAchievements.tr(),
      ),
      ProfileAchievementsListWidget(viewModel.user.id, true),
    ];
  }

  Widget _buildHeader(User user) {
    return SliverAppBar(
      expandedHeight: 350.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(user.name),
        background: _buildHeaderBackground(user.imageUrl),
      ),
    );
  }

  Widget _buildHeaderBackground(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
