import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/models/achievement_holder.dart';
import 'package:kudosapp/models/related_user.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/viewmodels/achievement_details_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_horizontal_widget.dart';

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
  final TextEditingController _inputController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
            title: Text(viewModel.achievementViewModel.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    EditAchievementRoute(
                      achievement: viewModel.achievementViewModel.achievement,
                    ),
                  );
                },
              ),
            ],
          ),
          body: _buildBody(viewModel),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.send),
            onPressed: _sendTapped,
          ),
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
            child: AchievementHorizontalWidget(viewModel.achievementViewModel),
          ),
          SizedBox(height: 24),
          _PopularityWidget(viewModel.statisticsValue),
          SizedBox(height: 24),
          _AchievementHoldersWidget(viewModel.achievementHolders),
          SizedBox(height: 24),
          _AchievementOwnerWidget(
              viewModel.ownerType, viewModel.ownerName, viewModel.ownerId)
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

        _notifyAboutSuccess();
      }
    } catch (error) {
      _notifyAboutError(error);
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

  void _notifyAboutSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "👍",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Text(
            localizer().sentSuccessfully,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 4),
    ));
  }

  void _notifyAboutError(error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        localizer().generalErrorMessage,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: Theme.of(context).errorColor,
      duration: Duration(seconds: 4),
    ));
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
        _SectionTitleWidget(localizer().achievementStatisticsTitle,
            localizer().achievementStatisticsTooltip),
        SizedBox(height: 12),
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
                          Theme.of(context).primaryColor),
                      backgroundColor: Theme.of(context).primaryColorLight,
                    ),
                  ),
                )))
      ],
    );
  }
}

class _SectionTitleWidget extends StatelessWidget {
  final String _title;
  final String _tooltipTitle;

  _SectionTitleWidget(this._title, [this._tooltipTitle]);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _title,
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(width: 8),
          Visibility(
              visible: _tooltipTitle?.isNotEmpty ?? false,
              child: Tooltip(
                message: _tooltipTitle ?? "not visible",
                child: Icon(
                  Icons.info,
                  size: 20,
                  color: Colors.grey,
                ),
              ))
        ]);
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
      _SectionTitleWidget(localizer().achievementOwnerTitle),
      SizedBox(height: 12),
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
  final List<AchievementHolder> _achievementHolders;

  _AchievementHoldersWidget(this._achievementHolders);

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_achievementHolders == null || _achievementHolders.length == 0) {
      content = Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                localizer().achievementHoldersEmptyPlaceholder,
                style: Theme.of(context).textTheme.bodyText1,
              )));
    } else {
      content = Padding(
          padding: EdgeInsets.only(left: 12),
          child: GridView.count(
              children: _buildListItems(context, _achievementHolders),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 7,
              physics: ClampingScrollPhysics()));
    }
    return Column(children: <Widget>[
      _SectionTitleWidget(localizer().achievementHoldersTitle),
      SizedBox(height: 12),
      content
    ]);
  }

  List<Widget> _buildListItems(
      BuildContext context, List<AchievementHolder> achievementHolders) {
    return achievementHolders == null
        ? new List<Widget>()
        : achievementHolders
            .map((u) => _buildUserAvatar(context, u.recipient))
            .toList();
  }

  Widget _buildUserAvatar(BuildContext context, RelatedUser holder) {
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
    RelatedUser holder,
  ) {
    Navigator.of(context).push(ProfileRoute(holder.id));
  }
}
