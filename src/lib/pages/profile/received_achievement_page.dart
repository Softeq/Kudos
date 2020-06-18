import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kudosapp/dto/user_achievement.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile/received_achievement_viewmodel.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:provider/provider.dart';

class ReceivedAchievementRoute extends MaterialPageRoute {
  ReceivedAchievementRoute(UserAchievementCollection achievementCollection)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<ReceivedAchievementViewModel>(
              create: (context) {
                return ReceivedAchievementViewModel(achievementCollection);
              },
              child: ReceivedAchievementPage(),
            );
          },
        );
}

class ReceivedAchievementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ReceivedAchievementViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.relatedAchievement.name),
      ),
      body: Consumer<ReceivedAchievementViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildBody(viewModel, context);
          }
        },
      ),
    );
  }

  Widget _buildBody(
      ReceivedAchievementViewModel viewModel, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: RoundedImageWidget.circular(
              imageViewModel: viewModel.achievementCollection.imageViewModel,
              size: 100.0,
            ),
            onTap: () {
              Navigator.of(context).push(
                AchievementDetailsRoute(viewModel.relatedAchievement.id),
              );
            },
          ),
          SizedBox(height: 20),
          ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black54,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: viewModel.achievementCollection.count,
            itemBuilder: (context, index) => _buildUserAchievementView(
                viewModel.achievementCollection.userAchievements[index],
                context),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAchievementView(
      UserAchievement userAchievementModel, BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context)
              .push(ProfileRoute(userAchievementModel.sender.id));
        },
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      userAchievementModel.sender.imageUrl),
                  radius: 25,
                ),
                SizedBox(width: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(userAchievementModel.sender.name,
                          style: TextStyle(fontSize: 14)),
                      Text(
                          DateFormat.yMd()
                              .add_jm()
                              .format(userAchievementModel.date.toDate()),
                          style:
                              TextStyle(fontSize: 12, color: Colors.black38)),
                    ])
              ]),
              SizedBox(height: 10),
              _buildCommentView(userAchievementModel.comment),
            ],
          ),
        ));
  }

  Widget _buildCommentView(String comment) {
    if (comment.isNotEmpty) {
      return Text(comment, style: TextStyle(fontSize: 16));
    } else {
      return Text(localizer().noComment,
          style: TextStyle(fontSize: 16, color: Colors.black26));
    }
  }
}
