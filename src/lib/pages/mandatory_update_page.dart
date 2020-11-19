import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/mandatory_update_viewmodel.dart';
import 'package:provider/provider.dart';

class MandatoryUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MandatoryUpdateViewModel>(
      builder: (context, vm, child) {
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
                  SizedBox(height: 16.0),
                  RaisedButton(
                    onPressed: vm.navigateToUpdatesPage,
                    child: Text(
                      localizer().update,
                      style: TextStyle(
                        color: KudosTheme.textColor,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: KudosTheme.accentColor,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
