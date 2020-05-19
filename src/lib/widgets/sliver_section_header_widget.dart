import 'package:flutter/material.dart';

class SliverSectionHeaderWidget extends StatelessWidget {
  final String title;

  const SliverSectionHeaderWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}