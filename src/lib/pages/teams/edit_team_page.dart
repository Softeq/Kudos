import 'package:flutter/material.dart';
import 'package:kudosapp/helpers/text_editing_value_helper.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/teams/edit_team_viewmodel.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class EditTeamRoute extends MaterialPageRoute {
  EditTeamRoute([TeamModel team])
      : super(
          builder: (context) {
            return ChangeNotifierProvider<EditTeamViewModel>(
              create: (context) {
                return EditTeamViewModel(team);
              },
              child: _EditTeamPage(),
            );
          },
          fullscreenDialog: true,
        );
}

class _EditTeamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditTeamPageState();
  }
}

class _EditTeamPageState extends State<_EditTeamPage> {
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
                autovalidate: false,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () => viewModel.pickFile(context),
                      child: RoundedImageWidget.square(
                        imageUrl: viewModel.imageUrl,
                        title: viewModel.name,
                        size: 112.0,
                        borderRadius: 8,
                        file: viewModel.imageFile,
                        addHeroAnimation: true,
                      ),
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
                        return x.isEmpty ? localizer().requiredField : null;
                      },
                      style: KudosTheme.descriptionTextStyle,
                      cursorColor: KudosTheme.accentColor,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: KudosTheme.accentColor)),
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
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: KudosTheme.accentColor)),
                      ),
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
              _nameController.text,
              _descriptionController.text,
            );
            Navigator.of(context).pop();
          }
        },
        label: Text(localizer().save),
        icon: Icon(Icons.save),
      ),
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
