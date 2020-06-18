import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/widgets/common/scroll_behaviors.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/people_viewmodel.dart';

class PeopleList extends StatelessWidget {
  final Function(User user) itemSelector;
  final Widget itemTrailing;

  const PeopleList(this.itemSelector, this.itemTrailing);

  @override
  Widget build(BuildContext context) {
    return Consumer<PeopleViewModel>(builder: (context, viewModel, child) {
      return StreamBuilder<List<User>>(
        stream: viewModel.people,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return _buildEmpty();
            }
            return _buildList(snapshot.data);
          }
          if (snapshot.hasError) {
            return _buildError(snapshot.error);
          }
          return _buildLoading();
        },
      );
    });
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Text(
        "Error: $error", // TODO YP: temporary
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text("No data"), // TODO YP: temporary
    );
  }

  Widget _buildList(List<User> users) {
    return ScrollConfiguration(
      behavior: DisableGlowingOverscrollBehavior(),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => _buildItem(context, users[index]),
      ),
    );
  }

  Widget _buildItem(BuildContext context, User user) {
    return InkWell(
      onTap: () {
        itemSelector(user);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(user.imageUrl),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: itemTrailing,
      ),
    );
  }
}
