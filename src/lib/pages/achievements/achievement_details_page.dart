import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/helpers/list_notifier.dart';
import 'package:kudosapp/models/statistics_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/pages/achievements/edit_achievement_page.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/snack_bar_notifier_service.dart';
import 'package:kudosapp/viewmodels/achievements/achievement_details_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/achievement_horizontal_widget.dart';
import 'package:kudosapp/widgets/common/fancy_item_widget.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:kudosapp/widgets/section_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class AchievementDetailsRoute extends MaterialPageRoute {
  AchievementDetailsRoute(AchievementModel achievementModel)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<AchievementDetailsViewModel>(
              create: (context) {
                return AchievementDetailsViewModel(achievementModel);
              },
              child: _AchievementDetailsPage(),
            );
          },
        );
}

class _AchievementDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AchievementDetailsPageState();
}

class _AchievementDetailsPageState extends State<_AchievementDetailsPage> {
  final _inputController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _snackBarNotifier = locator<SnackBarNotifierService>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementDetailsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: GradientAppBar(
            title: viewModel.achievement.name,
            actions: viewModel.canEdit()
                ? <Widget>[
                    IconButton(
                        icon: Icon(Icons.transfer_within_a_station),
                        onPressed: () =>
                            viewModel.transferAchievement(context)),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          EditAchievementRoute.editAchievement(
                            viewModel.achievement,
                          ),
                        );
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () => viewModel.deleteAchievement(context))
                  ]
                : null,
          ),
          body: _buildBody(viewModel),
          floatingActionButton: viewModel.canSend()
              ? FloatingActionButton(
                  child: Icon(Icons.send),
                  onPressed: _sendTapped,
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(AchievementDetailsViewModel viewModel) {
    var horizontalAchievement = Container(
      height: 140,
      child: AchievementHorizontalWidget(
        viewModel.achievement.imageUrl,
        viewModel.achievement.description,
      ),
    );

    if (viewModel.isBusy) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            horizontalAchievement,
            SizedBox(height: 100),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          horizontalAchievement,
          SizedBox(height: 24),
          _AchievementOwnerWidget(viewModel),
          SizedBox(height: 24),
          _buildStatisticsWidgets(viewModel),
          SizedBox(height: 24),
          ChangeNotifierProvider.value(
            value: viewModel.achievementHolders,
            child: Consumer<ListNotifier<UserModel>>(
              builder: (context, notifier, child) {
                return _AchievementHoldersWidget(
                  viewModel.achievementHolders,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsWidgets(AchievementDetailsViewModel viewModel) {
    var children = <Widget>[
      SectionHeaderWidget(localizer().achievementStatisticsTitle),
      SizedBox(height: 8.0),
      _PopularityWidget(viewModel.allUsersStatistics),
    ];

    if (viewModel.teamUsersStatistics != null) {
      children.add(SizedBox(
        height: 8.0,
      ));
      children.add(_PopularityWidget(viewModel.teamUsersStatistics));
    }

    return Column(
      children: children,
    );
  }

  Future<void> _sendTapped() async {
    var user = await Navigator.of(context).push(
      UserPickerRoute(
        allowMultipleSelection: false,
        allowCurrentUser: false,
        trailingBuilder: (context) {
          return Icon(Icons.send, color: KudosTheme.accentColor);
        },
      ),
    );
    if (user != null && user.isNotEmpty) {
      await _sendAchievementToUser(user.first);
    }
  }

  Future<void> _sendAchievementToUser(UserModel user) async {
    try {
      var commentText = await _putCommentDialog();
      if (commentText != null) {
        var viewModel =
            Provider.of<AchievementDetailsViewModel>(context, listen: false);
        await viewModel.sendTo(user, commentText);
      }
    } catch (error) {
      _snackBarNotifier.showGeneralErrorMessage(
          _scaffoldKey.currentContext, _scaffoldKey.currentState);
    }
  }

  Future<String> _putCommentDialog() async {
    bool accepted = false;

    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _inputController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: localizer().writeAComment,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(localizer().cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(localizer().send),
                onPressed: () {
                  accepted = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    var result = accepted ? _inputController.text : null;

    _inputController.text = "";

    return result;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}

class _PopularityWidget extends StatelessWidget {
  final StatisticsModel _popularityStatistics;

  _PopularityWidget(this._popularityStatistics);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraints) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 32,
                width: constraints.maxWidth,
                child: LinearProgressIndicator(
                  value: _popularityStatistics.ratio, // percent filled
                  valueColor: AlwaysStoppedAnimation<Color>(
                    KudosTheme.mainGradientEndColor,
                  ),
                  backgroundColor:
                      KudosTheme.mainGradientEndColor.withAlpha(120),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _popularityStatistics.title,
              style: KudosTheme.statisticsTitleTextStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              sprintf(localizer().people_progress, [
                _popularityStatistics.positiveUsersCount,
                _popularityStatistics.allUsersCount
              ]),
              style: KudosTheme.statisticsTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}

class _AchievementOwnerWidget extends StatelessWidget {
  final AchievementDetailsViewModel _viewModel;

  _AchievementOwnerWidget(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionHeaderWidget(localizer().achievementOwnerTitle),
        SizedBox(height: 8.0),
        Align(
          alignment: Alignment.topLeft,
          child: FancyItemWidget(
            _viewModel.achievement.owner.name,
            () => _viewModel.onOwnerClicked(context),
          ),
        ),
      ],
    );
  }
}

class _AchievementHoldersWidget extends StatelessWidget {
  final ListNotifier<UserModel> _achievementHolders;

  _AchievementHoldersWidget(this._achievementHolders);

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_achievementHolders == null || _achievementHolders.length == 0) {
      content = Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            localizer().achievementHoldersEmptyPlaceholder,
            style: KudosTheme.sectionEmptyTextStyle,
          ),
        ),
      );
    } else {
      content = Align(
        alignment: Alignment.topLeft,
        child: Wrap(
            children: _buildListItems(context, _achievementHolders),
            runSpacing: 10,
            spacing: 10),
      );
    }
    return Column(children: <Widget>[
      SectionHeaderWidget(localizer().achievementHoldersTitle),
      SizedBox(height: 8.0),
      content,
    ]);
  }

  List<Widget> _buildListItems(
      BuildContext context, ListNotifier<UserModel> achievementHolders) {
    return achievementHolders == null
        ? new List<Widget>()
        : achievementHolders.items
            .map((user) => _buildUserAvatar(context, user))
            .toList();
  }

  Widget _buildUserAvatar(BuildContext context, UserModel user) {
    return Tooltip(
      message: user.name,
      child: GestureDetector(
        child: RoundedImageWidget.circular(
          size: 60,
          imageUrl: user.imageUrl,
          title: user.name,
        ),
        onTap: () => Navigator.of(context).push(ProfileRoute(user)),
      ),
      decoration: KudosTheme.tooltipDecoration,
      textStyle: KudosTheme.tooltipTextStyle,
      verticalOffset: 33,
    );
  }
}
