import 'package:flutter/material.dart';

// TODO PS: Change it to Style instead of Widget
class Button extends StatelessWidget {

  final String title;
  final Function onPressed;

  Button(this.title, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      child: RaisedButton(
        child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600)
        ),
        textColor: Colors.white,
        color: Colors.blue,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.lightBlue)
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 0), // changes position of shadow
            )
          ]
      ),
    );
  }
}