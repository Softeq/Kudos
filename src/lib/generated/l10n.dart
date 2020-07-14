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
      'Sign in via Google',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  String get notSignedIn {
    return Intl.message(
      'Sign in to view your achievements',
      name: 'notSignedIn',
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

  String get name {
    return Intl.message(
      'Name',
      name: 'name',
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
      'Add a name',
      name: 'nameIsNullErrorMessage',
      desc: '',
      args: [],
    );
  }

  String get generalErrorMessage {
    return Intl.message(
      'Something went wrong',
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

  String get achievementStatisticsTitle {
    return Intl.message(
      'Global Progress',
      name: 'achievementStatisticsTitle',
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
      'No one has ever received this achievement',
      name: 'achievementHoldersEmptyPlaceholder',
      desc: '',
      args: [],
    );
  }

  String get profileAchievementsEmptyPlaceholder {
    return Intl.message(
      'No achievements yet',
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

  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  String get userTeamsEmptyPlaceholder {
    return Intl.message(
      'This user is not part of any team yet',
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

  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  String get deleteAchievementWarning {
    return Intl.message(
      'Do you really want to delete this achievement?',
      name: 'deleteAchievementWarning',
      desc: '',
      args: [],
    );
  }

  String get deleteTeamWarning {
    return Intl.message(
      'Do you really want to delete this team? All team\'s achievements will be removed as well',
      name: 'deleteTeamWarning',
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

  String get enterName {
    return Intl.message(
      'Enter name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  String get fileSizeTooBig {
    return Intl.message(
      'Image size should be less than 0.5Mb',
      name: 'fileSizeTooBig',
      desc: '',
      args: [],
    );
  }

  String get transferAchievementTitle {
    return Intl.message(
      'Transfer achievement',
      name: 'transferAchievementTitle',
      desc: '',
      args: [],
    );
  }

  String get transferAchievementDescription {
    return Intl.message(
      'Do you want to transfer this achievement to another user or another team?',
      name: 'transferAchievementDescription',
      desc: '',
      args: [],
    );
  }

  String get transferAchievementToUserTitle {
    return Intl.message(
      'Transfer to %s?',
      name: 'transferAchievementToUserTitle',
      desc: '',
      args: [],
    );
  }

  String get transferAchievementToTeamTitle {
    return Intl.message(
      'Transfer to %s team?',
      name: 'transferAchievementToTeamTitle',
      desc: '',
      args: [],
    );
  }

  String get transferAchievementToUserWarning {
    return Intl.message(
      'You will not have access to this achievement after the operation is complete',
      name: 'transferAchievementToUserWarning',
      desc: '',
      args: [],
    );
  }

  String get transferAchievementToTeamWarning {
    return Intl.message(
      'You might not have access to this achievement after the operation is complete',
      name: 'transferAchievementToTeamWarning',
      desc: '',
      args: [],
    );
  }

  String get noComment {
    return Intl.message(
      'No comment',
      name: 'noComment',
      desc: '',
      args: [],
    );
  }

  String get myAchievements {
    return Intl.message(
      'My Achievements',
      name: 'myAchievements',
      desc: '',
      args: [],
    );
  }

  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  String get searchMembers {
    return Intl.message(
      'Search Members',
      name: 'searchMembers',
      desc: '',
      args: [],
    );
  }

  String get searchAdmins {
    return Intl.message(
      'Search Admins',
      name: 'searchAdmins',
      desc: '',
      args: [],
    );
  }

  String get signOutConfirmationTitle {
    return Intl.message(
      'Are you sure?',
      name: 'signOutConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  String get signOutConfirmationMessage {
    return Intl.message(
      'Confirm that you really want to leave this super awesome app',
      name: 'signOutConfirmationMessage',
      desc: '',
      args: [],
    );
  }

  String get signOutConfirmButton {
    return Intl.message(
      'Sign Out',
      name: 'signOutConfirmButton',
      desc: '',
      args: [],
    );
  }

  String get signOutCancelButton {
    return Intl.message(
      'Stay!',
      name: 'signOutCancelButton',
      desc: '',
      args: [],
    );
  }

  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  String get detailedError {
    return Intl.message(
      'Error: %s',
      name: 'detailedError',
      desc: '',
      args: [],
    );
  }

  String get from {
    return Intl.message(
      'From: %s',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  String get receivedAchievements {
    return Intl.message(
      'Received achievements: %i',
      name: 'receivedAchievements',
      desc: '',
      args: [],
    );
  }

  String get profileTabName {
    return Intl.message(
      'Profile',
      name: 'profileTabName',
      desc: '',
      args: [],
    );
  }

  String get teamsTabName {
    return Intl.message(
      'Teams',
      name: 'teamsTabName',
      desc: '',
      args: [],
    );
  }

  String get peopleTabName {
    return Intl.message(
      'People',
      name: 'peopleTabName',
      desc: '',
      args: [],
    );
  }

  String get achievementsTabName {
    return Intl.message(
      'Library',
      name: 'achievementsTabName',
      desc: '',
      args: [],
    );
  }

  String get softeq {
    return Intl.message(
      'Softeq',
      name: 'softeq',
      desc: '',
      args: [],
    );
  }

  String get people_progress {
    return Intl.message(
      '%i of %i people',
      name: 'people_progress',
      desc: '',
      args: [],
    );
  }

  String get user_picker_empty_message {
    return Intl.message(
      'Select at least one user',
      name: 'user_picker_empty_message',
      desc: '',
      args: [],
    );
  }

  String get searchEmptyPlaceholder {
    return Intl.message(
      'No search results',
      name: 'searchEmptyPlaceholder',
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