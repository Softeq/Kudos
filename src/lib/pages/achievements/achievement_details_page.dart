import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/dto/achievement_holder.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/dto/user_reference.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/pages/achievements/edit_achievement_page.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/achievements/achievement_details_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_horizontal_widget.dart';
import 'package:kudosapp/widgets/section_header_widget.dart';
import 'package:kudosapp/widgets/snack_bar_notifier.dart';
import 'package:provider/provider.dart';

class AchievementDetailsRoute extends MaterialPageRoute {
  AchievementDetailsRoute(String achievementId)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<AchievementDetailsViewModel>(
              create: (context) {
                return AchievementDetailsViewModel(achievementId)..initialize();
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
  final _snackBarNotifier = SnackBarNotifier();

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementDetailsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(viewModel.achievementModel.title),
            actions: viewModel.canEdit
                ? <Widget>[
                  IconButton(
                        icon: Icon(Icons.transfer_within_a_station),
                        onPressed: () => viewModel.transferAchievement(context)),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          EditAchievementRoute.editAchievement(
                              viewModel.achievementModel.achievement),
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
          floatingActionButton: viewModel.canSend
              ? FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.send),
                  onPressed: _sendTapped,
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(AchievementDetailsViewModel viewModel) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 140,
            child: AchievementHorizontalWidget(viewModel.achievementModel),
          ),
          SizedBox(height: 24),
          _PopularityWidget(viewModel.statisticsValue),
          SizedBox(height: 24),
          ChangeNotifierProvider.value(
            value: viewModel.achievementHolders,
            child: Consumer<ListNotifier<AchievementHolder>>(
              builder: (context, notifier, child) {
                return _AchievementHoldersWidget(
                  viewModel.achievementHolders,
                );
              },
            ),
          ),
          SizedBox(height: 24),
          _AchievementOwnerWidget(
            viewModel.ownerType,
            viewModel.ownerName,
            viewModel.ownerId,
          )
        ],
      ),
    );
  }

  Future<void> _sendTapped() async {
    var user = await Navigator.of(context).push(
      UserPickerRoute(
        allowMultipleSelection: false,
        allowCurrentUser: false,
        trailingBuilder: (context) {
          return Icon(Icons.send);
        },
      ),
    );
    if (user != null && user.isNotEmpty) {
      await _sendAchievementToUser(user.first);
    }
  }

  Future<void> _sendAchievementToUser(User user) async {
    try {
      var commentText = await _putCommentDialog();
      if (commentText != null) {
        var viewModel =
            Provider.of<AchievementDetailsViewModel>(context, listen: false);
        await viewModel.sendTo(user, commentText);

        // _snackBarNotifier.showSuccessMessage(_scaffoldKey.currentContext,
        //     _scaffoldKey.currentState, localizer().sentSuccessfully);
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
  final double _popularityPercent;

  _PopularityWidget(this._popularityPercent);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SectionHeaderWidget(
          localizer().achievementStatisticsTitle,
          localizer().achievementStatisticsTooltip,
        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Align(
            alignment: Alignment.topLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 16,
                width: 144,
                child: LinearProgressIndicator(
                  value: _popularityPercent, // percent filled
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  backgroundColor: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _AchievementOwnerWidget extends StatelessWidget {
  final String _ownerName;
  final String _ownerId;
  final OwnerType _ownerType;

  _AchievementOwnerWidget(this._ownerType, this._ownerName, this._ownerId);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SectionHeaderWidget(localizer().achievementOwnerTitle),
      Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: RaisedButton(
                  onPressed: () {
                    switch (_ownerType) {
                      case OwnerType.user:
                        Navigator.of(context).push(ProfileRoute(_ownerId));
                        break;
                      case OwnerType.team:
                        Navigator.of(context).push(ManageTeamRoute(_ownerId));
                        break;
                    }
                  },
                  child: Text(_ownerName,
                      style: Theme.of(context).textTheme.bodyText1))))
    ]);
  }
}

class _AchievementHoldersWidget extends StatelessWidget {
  final ListNotifier<AchievementHolder> _achievementHolders;

  _AchievementHoldersWidget(this._achievementHolders);

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_achievementHolders == null || _achievementHolders.items.length == 0) {
      content = Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            localizer().achievementHoldersEmptyPlaceholder,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      );
    } else {
      content = Padding(
          padding: EdgeInsets.only(left: 12),
          child: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                  children: _buildListItems(context, _achievementHolders),
                  spacing: 10)));
    }
    return Column(children: <Widget>[
      SectionHeaderWidget(localizer().achievementHoldersTitle),
      content,
    ]);
  }

  List<Widget> _buildListItems(BuildContext context,
      ListNotifier<AchievementHolder> achievementHolders) {
    return achievementHolders == null
        ? new List<Widget>()
        : achievementHolders.items
            .map((u) => _buildUserAvatar(context, u.recipient))
            .toList();
  }

  Widget _buildUserAvatar(BuildContext context, UserReference holder) {
    return Tooltip(
      message: holder.name,
      child: GestureDetector(
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(holder.imageUrl),
        ),
        onTap: () => _navigateToProfile(context, holder),
      ),
    );
  }

  void _navigateToProfile(
    BuildContext context,
    UserReference holder,
  ) {
    Navigator.of(context).push(ProfileRoute(holder.id));
  }
}
