import 'dart:io';

import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class MandatoryUpdateViewModel extends BaseViewModel {
  Future<void> navigateToUpdatesPage() async {
    String url;

    if (Platform.isAndroid) {
      url =
          "https://install.appcenter.ms/orgs/softeqdevelopment/apps/kudos.android/distribution_groups/dev%20team";
    } else if (Platform.isIOS) {
      url =
          "https://install.appcenter.ms/orgs/softeqdevelopment/apps/kudos.ios/distribution_groups/dev%20team";
    } else {
      url = null;
    }

    if (url == null) {
      return;
    }

    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
