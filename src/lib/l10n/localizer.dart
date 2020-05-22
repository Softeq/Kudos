import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/l10n/keys.dart';

class Localizer implements WidgetsLocalizations {
  final Locale locale;

  static LocalizationsDelegate<Localizer> delegate = _LocalizerDelegate();

  const Localizer(this.locale);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  static Localizer of(BuildContext context) {
    return Localizations.of<Localizer>(context, Localizer);
  }

  String get edit => this._translate(LocalizerKeys.edit);
  String get signIn => this._translate(LocalizerKeys.signIn);
  String get allAchievements => this._translate(LocalizerKeys.allAchievements);
  String get fromCris => this._translate(LocalizerKeys.fromCris);
  String get official => this._translate(LocalizerKeys.official);
  String get others => this._translate(LocalizerKeys.others);
  String get people => this._translate(LocalizerKeys.people);
  String get profile => this._translate(LocalizerKeys.profile);
  String get ok => this._translate(LocalizerKeys.ok);
  String get cancel => this._translate(LocalizerKeys.cancel);
  String get achievementName => this._translate(LocalizerKeys.achievementName);
  String get description => this._translate(LocalizerKeys.description);
  String get editName => this._translate(LocalizerKeys.editName);
  String get editDescription => this._translate(LocalizerKeys.editDescription);
  String get editImage => this._translate(LocalizerKeys.editImage);
  String get appName => this._translate(LocalizerKeys.appName);
  String get create => this._translate(LocalizerKeys.create);
  String get fileIsNullErrorMessage =>
      this._translate(LocalizerKeys.fileIsNullErrorMessage);
  String get descriptionIsNullErrorMessage =>
      this._translate(LocalizerKeys.descriptionIsNullErrorMessage);
  String get nameIsNullErrorMessage =>
      this._translate(LocalizerKeys.nameIsNullErrorMessage);
  String get generalErrorMessage =>
      this._translate(LocalizerKeys.generalErrorMessage);
  String get send => this._translate(LocalizerKeys.send);
  String get writeAComment => this._translate(LocalizerKeys.writeAComment);
  String get sentSuccessfully =>
      this._translate(LocalizerKeys.sentSuccessfully);
  String get achievementStatisticsTitle =>
      this._translate(LocalizerKeys.achievementStatisticsTitle);
  String get achievementStatisticsTooltip =>
      this._translate(LocalizerKeys.achievementStatisticsTooltip);
  String get achievementHoldersTitle =>
      this._translate(LocalizerKeys.achievementHoldersTitle);
  String get achievementHoldersEmptyPlaceholder =>
      this._translate(LocalizerKeys.achievementHoldersEmptyPlaceholder);
  String get profileAchievementsEmptyPlaceholder =>
      this._translate(LocalizerKeys.profileAchievementsEmptyPlaceholder);
  String get createYourOwnTeams =>
      this._translate(LocalizerKeys.createYourOwnTeams);
  String get addPeople => this._translate(LocalizerKeys.addPeople);
  String get addedPeople => this._translate(LocalizerKeys.addedPeople);
  String get createTeam => this._translate(LocalizerKeys.createTeam);
  String get editTeam => this._translate(LocalizerKeys.editTeam);
  String get name => this._translate(LocalizerKeys.name);
  String get optionalDescription =>
      this._translate(LocalizerKeys.optionalDescription);
  String get requiredField => this._translate(LocalizerKeys.requiredField);
  String get team => this._translate(LocalizerKeys.team);
  String get admins => this._translate(LocalizerKeys.admins);
  String get teams => this._translate(LocalizerKeys.teams);
  String get owner => this._translate(LocalizerKeys.owner);
  String get members => this._translate(LocalizerKeys.members);
  String get save => this._translate(LocalizerKeys.save);
  String get achievements => this._translate(LocalizerKeys.achievements);
  String get createYourOwnAchievements =>
      this._translate(LocalizerKeys.createYourOwnAchievements);
  String get achievementOwnerTitle =>
      this._translate(LocalizerKeys.achievementOwnerTitle);

  /// Returns the requested string resource associated with the given [key].
  String _translate(String key) => "${locale.languageCode}-$key";
}

class _LocalizerDelegate extends LocalizationsDelegate<Localizer> {
  const _LocalizerDelegate();

  List<Locale> get supportedLocales {
    return [
      Locale('en'),
      Locale('ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }

  @override
  Future<Localizer> load(Locale locale) {
    return SynchronousFuture<Localizer>(Localizer(locale));
  }

  @override
  bool shouldReload(_LocalizerDelegate old) => false;
}
