import 'package:flutter/material.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/helpers/text_editing_value_helper.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/teams/edit_team_viewmodel.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';

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
                    SizedBox(height: 24.0),
                    GestureDetector(
                      onTap: () => viewModel.pickFile(context),
                      child: RoundedImageWidget.circular(
                        imageViewModel: viewModel.imageViewModel,
                        name: viewModel.initialName,
                        size: 100.0,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(localizer().name),
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (x) {
                        return x.isEmpty ? localizer().requiredField : null;
                      },
                    ),
                    SizedBox(height: 36.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(localizer().optionalDescription),
                    ),
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
        label: Text(localizer().save),
        icon: Icon(Icons.save),
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
