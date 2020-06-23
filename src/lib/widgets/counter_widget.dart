import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int count;
  final double height;

  CounterWidget({
    @required this.count,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final verticalPadding = height * 0.1;
    final horizontalPadding = height * 0.17;
    final borderWidth = height * 0.05;
    final outerBorderRadius = height * 0.5;
    final innerBorderRadius = outerBorderRadius - borderWidth;

    return ClipRRect(
      borderRadius: BorderRadius.circular(outerBorderRadius),
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(borderWidth),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(innerBorderRadius),
                  child: Container(
                    color: Colors.amber[900],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              child: FittedBox(
                child: Text(
                  "x$count",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
