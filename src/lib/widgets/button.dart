import 'package:flutter/material.dart';

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
        textColor: Theme.of(context).textTheme.bodyText1.color,
        color: Theme.of(context).primaryColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Theme.of(context).primaryColorLight)
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