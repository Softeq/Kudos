import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/service_locator.dart';

class MandatoryUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/img_update.svg",
              ),
              SizedBox(height: 16.0),
              Text(
                localizer().updateRequired,
                style: KudosTheme.listTitleTextStyle,
              ),
              SizedBox(height: 16.0),
              Text(
                localizer().updateRequiredMessage,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
