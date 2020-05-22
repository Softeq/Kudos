// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get appName {
    return Intl.message(
      'Kudos',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  String get signIn {
    return Intl.message(
      'Sign-In via Google',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  String get allAchievements {
    return Intl.message(
      'All achievements',
      name: 'allAchievements',
      desc: '',
      args: [],
    );
  }

  String get fromCris {
    return Intl.message(
      'From Chris',
      name: 'fromCris',
      desc: '',
      args: [],
    );
  }

  String get official {
    return Intl.message(
      'Official',
      name: 'official',
      desc: '',
      args: [],
    );
  }

  String get others {
    return Intl.message(
      'Others',
      name: 'others',
      desc: '',
      args: [],
    );
  }

  String get people {
    return Intl.message(
      'People',
      name: 'people',
      desc: '',
      args: [],
    );
  }

  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  String get achievementName {
    return Intl.message(
      'Name',
      name: 'achievementName',
      desc: '',
      args: [],
    );
  }

  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  String get editName {
    return Intl.message(
      'Make the name unique',
      name: 'editName',
      desc: '',
      args: [],
    );
  }

  String get editDescription {
    return Intl.message(
      'Make the description meaningful',
      name: 'editDescription',
      desc: '',
      args: [],
    );
  }

  String get editImage {
    return Intl.message(
      'Make the image recognizable',
      name: 'editImage',
      desc: '',
      args: [],
    );
  }

  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  String get fileIsNullErrorMessage {
    return Intl.message(
      'Add a picture',
      name: 'fileIsNullErrorMessage',
      desc: '',
      args: [],
    );
  }

  String get descriptionIsNullErrorMessage {
    return Intl.message(
      'Add a description',
      name: 'descriptionIsNullErrorMessage',
      desc: '',
      args: [],
    );
  }

  String get nameIsNullErrorMessage {
    return Intl.message(
      'Enter name',
      name: 'nameIsNullErrorMessage',
      desc: '',
      args: [],
    );
  }

  String get generalErrorMessage {
    return Intl.message(
      'Something went wrong...',
      name: 'generalErrorMessage',
      desc: '',
      args: [],
    );
  }

  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  String get writeAComment {
    return Intl.message(
      'Your comment',
      name: 'writeAComment',
      desc: '',
      args: [],
    );
  }

  String get sentSuccessfully {
    return Intl.message(
      'The award has been successfully sent!',
      name: 'sentSuccessfully',
      desc: '',
      args: [],
    );
  }

  String get achievementStatisticsTitle {
    return Intl.message(
      'Statistics',
      name: 'achievementStatisticsTitle',
      desc: '',
      args: [],
    );
  }

  String get achievementStatisticsTooltip {
    return Intl.message(
      'How many people have already received this award',
      name: 'achievementStatisticsTooltip',
      desc: '',
      args: [],
    );
  }

  String get achievementHoldersTitle {
    return Intl.message(
      'Holders',
      name: 'achievementHoldersTitle',
      desc: '',
      args: [],
    );
  }

  String get achievementHoldersEmptyPlaceholder {
    return Intl.message(
      'No one has ever received this achievement.',
      name: 'achievementHoldersEmptyPlaceholder',
      desc: '',
      args: [],
    );
  }

  String get profileAchievementsEmptyPlaceholder {
    return Intl.message(
      'Haven\'t received any achievements yet.',
      name: 'profileAchievementsEmptyPlaceholder',
      desc: '',
      args: [],
    );
  }

  String get achievementOwnerTitle {
    return Intl.message(
      'Owner',
      name: 'achievementOwnerTitle',
      desc: '',
      args: [],
    );
  }

  String get addPeople {
    return Intl.message(
      'Add people',
      name: 'addPeople',
      desc: '',
      args: [],
    );
  }

  String get addedPeople {
    return Intl.message(
      'Added people',
      name: 'addedPeople',
      desc: '',
      args: [],
    );
  }

  String get createTeam {
    return Intl.message(
      'Create team',
      name: 'createTeam',
      desc: '',
      args: [],
    );
  }

  String get editTeam {
    return Intl.message(
      'Edit team',
      name: 'editTeam',
      desc: '',
      args: [],
    );
  }

  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  String get optionalDescription {
    return Intl.message(
      'Description (optional)',
      name: 'optionalDescription',
      desc: '',
      args: [],
    );
  }

  String get requiredField {
    return Intl.message(
      'Required field',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  String get team {
    return Intl.message(
      'Team',
      name: 'team',
      desc: '',
      args: [],
    );
  }

  String get userTeamsEmptyPlaceholder {
    return Intl.message(
      'This user is not yet part of any team',
      name: 'userTeamsEmptyPlaceholder',
      desc: '',
      args: [],
    );
  }

  String get admins {
    return Intl.message(
      'Admins',
      name: 'admins',
      desc: '',
      args: [],
    );
  }

  String get teams {
    return Intl.message(
      'Teams',
      name: 'teams',
      desc: '',
      args: [],
    );
  }

  String get owner {
    return Intl.message(
      'Owner',
      name: 'owner',
      desc: '',
      args: [],
    );
  }

  String get members {
    return Intl.message(
      'Members',
      name: 'members',
      desc: '',
      args: [],
    );
  }

  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  String get achievements {
    return Intl.message(
      'Achievements',
      name: 'achievements',
      desc: '',
      args: [],
    );
  }

  String get createYourOwnAchievements {
    return Intl.message(
      'Create your own rewards and give them to your colleagues!',
      name: 'createYourOwnAchievements',
      desc: '',
      args: [],
    );
  }

  String get createYourOwnTeams {
    return Intl.message(
      'Create your teams and invite your colleagues to join them!',
      name: 'createYourOwnTeams',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}