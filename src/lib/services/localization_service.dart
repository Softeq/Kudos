import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LocalizationService {
  String get appName => "Kudos";

  String get signIn => "Войти через Google";

  String get allAchievements => "Все награды";

  String get fromCris => "От Криса";

  String get official => "Официальные";

  String get others => "Остальные";

  String get people => "Люди";

  String get profile => "Профиль";

  String get ok => "OK";

  String get cancel => "Отмена";

  String get achievementName => "Название";

  String get description => "Описание";

  String get editName => "Сделай название уникальным";

  String get editDescription => "Сделай описание значимым";

  String get editImage => "Сделай изображение узнаваемым";

  String get edit => "Редактировать";

  String get create => "Создать";

  String get fileIsNullErrorMessage => "Добавьте картинку";

  String get descriptionIsNullErrorMessage => "Добавьте описание";

  String get nameIsNullErrorMessage => "Введите название";

  String get generalErrorMessage => "Что-то пошло не так...";

  String get send => "Отправить";

  String get writeAComment => "Ваш комментарий";

  String get sentSuccessfully => "Награда успешно отправлена!";

  String get achievementStatisticsTitle => "Статистика";

  String get achievementStatisticsTooltip =>
      "Как много людей уже получили эту награду";

  String get achievementHoldersTitle => "Обладатели";

  String get achievementHoldersEmptyPlaceholder =>
      "Никто ещё не получал эту награду";

  String get profileAchievementsEmptyPlaceholder => "Еще не получал наград";

  String get achievementOwnerTitle => "Владелец";

  String get addPeople => "Добавить людей";

  String get addedPeople => "Добавленные люди";

  String get createTeam => "Создание команды";

  String get editTeam => "Редактирование команды";

  String get name => "Имя";

  String get optionalDescription => "Описание (опционально)";

  String get requiredField => "Обязательное поле";

  String get team => "Команда";

  String get admins => "Администраторы";

  String get teams => "Команды";

  String get owner => "Владелец";

  String get members => "Состав";

  String get save => "Сохранить";

  String get achievements => "Достижения";

  String get createYourOwnAchievements =>
      "Создавайте свои собственные награды и дарите их своим коллегам!";

  String get createYourOwnTeams =>
      "Создавайте свои команды и приглашайте в них своих коллег!";
}

class Localization {
  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  List<Locale> get supportedLocales => delegate.supportedLocales;

  List<LocalizationsDelegate> get localizationsDelegates {
    return [
      delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }
}

class AppLocalizations implements WidgetsLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Hello World',
    },
    'ru': {
      'title': 'Привет мир',
    },
  };

  String get title => _localizedValues[locale.languageCode]['title'];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

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
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
