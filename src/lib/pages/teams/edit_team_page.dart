import 'package:flutter/material.dart';
import 'package:kudosapp/helpers/access_level_utils.dart';
import 'package:kudosapp/helpers/text_editing_value_helper.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/access_level.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/teams/edit_team_viewmodel.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class EditTeamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditTeamPageState();
  }
}

class _EditTeamPageState extends State<EditTeamPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditTeamViewModel>(context, listen: false);

    return Scaffold(
      appBar: GradientAppBar(title: viewModel.pageTitle),
      body: Consumer<EditTeamViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () => viewModel.pickFile(context),
                      child: _EditableRoundRectImage(viewModel, 112.0, 8.0),
                    ),
                    SizedBox(height: 36.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        localizer().name,
                        style: KudosTheme.listTitleTextStyle,
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (x) {
                        return x.trim().isEmpty
                            ? localizer().requiredField
                            : null;
                      },
                      style: KudosTheme.descriptionTextStyle,
                      cursorColor: KudosTheme.accentColor,
                      decoration: InputDecoration(
                        hintStyle: KudosTheme.hintTextStyle,
                        hintText: localizer().teamNamePlaceholder,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: KudosTheme.accentColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 36.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        localizer().description,
                        style: KudosTheme.listTitleTextStyle,
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      minLines: null,
                      style: KudosTheme.descriptionTextStyle,
                      cursorColor: KudosTheme.accentColor,
                      decoration: InputDecoration(
                        hintStyle: KudosTheme.hintTextStyle,
                        hintText: localizer().teamDescriptionPlaceholder,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: KudosTheme.accentColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          localizer().accessLevel,
                          style: KudosTheme.listTitleTextStyle,
                        ),
                        SizedBox(width: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            _buildDropdown(viewModel),
                            SizedBox(width: 18),
                            Expanded(
                              child: Text(
                                AccessLevelUtils.getDescription(
                                  viewModel.accessLevel,
                                ),
                                textAlign: TextAlign.end,
                                maxLines: 5,
                                style: KudosTheme.sectionHintTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            var viewModel =
                Provider.of<EditTeamViewModel>(context, listen: false);
            if (viewModel.isBusy) {
              return;
            }
            await viewModel.save(
              context,
              _nameController.text,
              _descriptionController.text,
            );
          }
        },
        label: Text(localizer().save),
        icon: KudosTheme.saveIcon,
      ),
    );
  }

  Widget _buildDropdown(EditTeamViewModel viewModel) {
    return DropdownButton<AccessLevel>(
      value: viewModel.accessLevel,
      items: AccessLevelUtils.getAllAccessLevels()
          .map<DropdownMenuItem<AccessLevel>>(
        (AccessLevel value) {
          return DropdownMenuItem<AccessLevel>(
            value: value,
            child: Text(AccessLevelUtils.getString(value)),
          );
        },
      ).toList(),
      onChanged: (AccessLevel value) => viewModel.accessLevel = value,
      style: KudosTheme.descriptionTextStyle,
    );
  }

  @override
  void initState() {
    var viewModel = Provider.of<EditTeamViewModel>(context, listen: false);
    _nameController.value = TextEditingValueHelper.buildForText(viewModel.name);
    _descriptionController.value =
        TextEditingValueHelper.buildForText(viewModel.description);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class _EditableRoundRectImage extends StatelessWidget {
  final EditTeamViewModel _viewModel;
  final double _size;
  final double _borderRadius;

  _EditableRoundRectImage(this._viewModel, this._size, this._borderRadius);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<EditTeamViewModel>(
        builder: (context, viewModel, child) {
          Widget child;

          if (viewModel.isImageLoading) {
            child = Center(
              child: CircularProgressIndicator(),
            );
          } else {
            child = RoundedImageWidget.square(
              imageUrl: viewModel.imageUrl,
              size: _size,
              borderRadius: _borderRadius,
              file: viewModel.imageFile,
              placeholderColor: KudosTheme.contentColor,
              addHeroAnimation: true,
            );
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: Container(
              width: _size,
              height: _size,
              color: KudosTheme.contentColor,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
