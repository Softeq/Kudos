import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kudosapp/generated/locale_keys.g.dart';
import 'package:kudosapp/helpers/text_editing_value_helper.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/viewmodels/teams/edit_team_viewmodel.dart';

class EditTeamRoute extends MaterialPageRoute<Team> {
  EditTeamRoute([Team team])
      : super(
          builder: (context) {
            return ChangeNotifierProvider<EditTeamViewModel>(
              create: (context) {
                return EditTeamViewModel.fromTeam(team);
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
      appBar: AppBar(
        title: Text(
          viewModel.isCreating
              ? LocaleKeys.createTeam.tr()
              : LocaleKeys.editTeam.tr(),
        ),
      ),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 24.0),
                    Text(LocaleKeys.name.tr()),
                    TextFormField(
                      controller: _nameController,
                      validator: (x) {
                        if (x.isEmpty) {
                          return LocaleKeys.requiredField.tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 36.0),
                    Text(LocaleKeys.optionalDescription.tr()),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      minLines: null,
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
            var team = await viewModel.save(
              _nameController.text,
              _descriptionController.text,
            );
            Navigator.of(context).pop(team);
          }
        },
        label: Text(LocaleKeys.save.tr()),
        icon: Icon(Icons.create),
      ),
    );
  }

  @override
  void initState() {
    var viewModel = Provider.of<EditTeamViewModel>(context, listen: false);
    _nameController.value =
        TextEditingValueHelper.buildForText(viewModel.initialName);
    _descriptionController.value =
        TextEditingValueHelper.buildForText(viewModel.initialDescription);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
