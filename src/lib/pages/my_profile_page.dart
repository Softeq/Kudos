import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/my_profile_viewmodel.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProfileViewModel>(
      builder: (context, viewModel, child) {
        final user = viewModel.profile.user;

        return Scaffold(
          appBar: AppBar(
            title: Text(locator<LocalizationService>().profile),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      user.imageUrl,
                    ),
                  ),
                  title: Text(user.name ?? ''),
                  subtitle: Text(user.email ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: viewModel.auth.signOut,
                  ),
                ),
              ),
              ProfileAchievementsList(viewModel.profile),
            ],
          ),
        );
      },
    );
  }
}
