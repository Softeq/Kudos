// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Kudos`
  String get appName {
    return Intl.message(
      'Kudos',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Sign-In via Google`
  String get signIn {
    return Intl.message(
      'Sign-In via Google',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to view your achievements`
  String get notSignedIn {
    return Intl.message(
      'Sign in to view your achievements',
      name: 'notSignedIn',
      desc: '',
      args: [],
    );
  }

  /// `People`
  String get people {
    return Intl.message(
      'People',
      name: 'people',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get achievementName {
    return Intl.message(
      'Name',
      name: 'achievementName',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Make the name unique`
  String get editName {
    return Intl.message(
      'Make the name unique',
      name: 'editName',
      desc: '',
      args: [],
    );
  }

  /// `Make the description meaningful`
  String get editDescription {
    return Intl.message(
      'Make the description meaningful',
      name: 'editDescription',
      desc: '',
      args: [],
    );
  }

  /// `Make the image recognizable`
  String get editImage {
    return Intl.message(
      'Make the image recognizable',
      name: 'editImage',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Add a picture`
  String get fileIsNullErrorMessage {
    return Intl.message(
      'Add a picture',
      name: 'fileIsNullErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Add a description`
  String get descriptionIsNullErrorMessage {
    return Intl.message(
      'Add a description',
      name: 'descriptionIsNullErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get nameIsNullErrorMessage {
    return Intl.message(
      'Enter name',
      name: 'nameIsNullErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong...`
  String get generalErrorMessage {
    return Intl.message(
      'Something went wrong...',
      name: 'generalErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Your comment`
  String get writeAComment {
    return Intl.message(
      'Your comment',
      name: 'writeAComment',
      desc: '',
      args: [],
    );
  }

  /// `The award has been successfully sent!`
  String get sentSuccessfully {
    return Intl.message(
      'The award has been successfully sent!',
      name: 'sentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Global Progress`
  String get achievementStatisticsTitle {
    return Intl.message(
      'Global Progress',
      name: 'achievementStatisticsTitle',
      desc: '',
      args: [],
    );
  }

  /// `How many people have already received this award`
  String get achievementStatisticsTooltip {
    return Intl.message(
      'How many people have already received this award',
      name: 'achievementStatisticsTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Holders`
  String get achievementHoldersTitle {
    return Intl.message(
      'Holders',
      name: 'achievementHoldersTitle',
      desc: '',
      args: [],
    );
  }

  /// `No one has ever received this achievement`
  String get achievementHoldersEmptyPlaceholder {
    return Intl.message(
      'No one has ever received this achievement',
      name: 'achievementHoldersEmptyPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `No achievements yet`
  String get profileAchievementsEmptyPlaceholder {
    return Intl.message(
      'No achievements yet',
      name: 'profileAchievementsEmptyPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Owner`
  String get achievementOwnerTitle {
    return Intl.message(
      'Owner',
      name: 'achievementOwnerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add people`
  String get addPeople {
    return Intl.message(
      'Add people',
      name: 'addPeople',
      desc: '',
      args: [],
    );
  }

  /// `Added people`
  String get addedPeople {
    return Intl.message(
      'Added people',
      name: 'addedPeople',
      desc: '',
      args: [],
    );
  }

  /// `Create team`
  String get createTeam {
    return Intl.message(
      'Create team',
      name: 'createTeam',
      desc: '',
      args: [],
    );
  }

  /// `Edit team`
  String get editTeam {
    return Intl.message(
      'Edit team',
      name: 'editTeam',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Required field`
  String get requiredField {
    return Intl.message(
      'Required field',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Team`
  String get team {
    return Intl.message(
      'Team',
      name: 'team',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `This user is not yet part of any team`
  String get userTeamsEmptyPlaceholder {
    return Intl.message(
      'This user is not yet part of any team',
      name: 'userTeamsEmptyPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Admins`
  String get admins {
    return Intl.message(
      'Admins',
      name: 'admins',
      desc: '',
      args: [],
    );
  }

  /// `Teams`
  String get teams {
    return Intl.message(
      'Teams',
      name: 'teams',
      desc: '',
      args: [],
    );
  }

  /// `Members`
  String get members {
    return Intl.message(
      'Members',
      name: 'members',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete this achievement?`
  String get deleteAchievementWarning {
    return Intl.message(
      'Do you really want to delete this achievement?',
      name: 'deleteAchievementWarning',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete this team? All the team achievements will be removed as well`
  String get deleteTeamWarning {
    return Intl.message(
      'Do you really want to delete this team? All the team achievements will be removed as well',
      name: 'deleteTeamWarning',
      desc: '',
      args: [],
    );
  }

  /// `Achievements`
  String get achievements {
    return Intl.message(
      'Achievements',
      name: 'achievements',
      desc: '',
      args: [],
    );
  }

  /// `Create your own rewards and give them to your colleagues!`
  String get createYourOwnAchievements {
    return Intl.message(
      'Create your own rewards and give them to your colleagues!',
      name: 'createYourOwnAchievements',
      desc: '',
      args: [],
    );
  }

  /// `Create your teams and invite your colleagues to join them!`
  String get createYourOwnTeams {
    return Intl.message(
      'Create your teams and invite your colleagues to join them!',
      name: 'createYourOwnTeams',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get enterName {
    return Intl.message(
      'Enter name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Image size is too big. Please select another file`
  String get fileSizeTooBig {
    return Intl.message(
      'Image size is too big. Please select another file',
      name: 'fileSizeTooBig',
      desc: '',
      args: [],
    );
  }

  /// `Transfer achievement`
  String get transferAchievementTitle {
    return Intl.message(
      'Transfer achievement',
      name: 'transferAchievementTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to trasfer this achievement to another user or another team?`
  String get transferAchievementDescription {
    return Intl.message(
      'Do you want to trasfer this achievement to another user or another team?',
      name: 'transferAchievementDescription',
      desc: '',
      args: [],
    );
  }

  /// `Transfer to %s?`
  String get transferAchievementToUserTitle {
    return Intl.message(
      'Transfer to %s?',
      name: 'transferAchievementToUserTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transfer to %s team?`
  String get transferAchievementToTeamTitle {
    return Intl.message(
      'Transfer to %s team?',
      name: 'transferAchievementToTeamTitle',
      desc: '',
      args: [],
    );
  }

  /// `You will not have access to this achievement after the operation is complete`
  String get transferAchievementToUserWarning {
    return Intl.message(
      'You will not have access to this achievement after the operation is complete',
      name: 'transferAchievementToUserWarning',
      desc: '',
      args: [],
    );
  }

  /// `You might not have access to this achievement after the operation is complete`
  String get transferAchievementToTeamWarning {
    return Intl.message(
      'You might not have access to this achievement after the operation is complete',
      name: 'transferAchievementToTeamWarning',
      desc: '',
      args: [],
    );
  }

  /// `No comment`
  String get noComment {
    return Intl.message(
      'No comment',
      name: 'noComment',
      desc: '',
      args: [],
    );
  }

  /// `Choose team`
  String get chooseTeam {
    return Intl.message(
      'Choose team',
      name: 'chooseTeam',
      desc: '',
      args: [],
    );
  }

  /// `My achievements`
  String get myAchievements {
    return Intl.message(
      'My achievements',
      name: 'myAchievements',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Search Members`
  String get searchMembers {
    return Intl.message(
      'Search Members',
      name: 'searchMembers',
      desc: '',
      args: [],
    );
  }

  /// `Search Admins`
  String get searchAdmins {
    return Intl.message(
      'Search Admins',
      name: 'searchAdmins',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get signOutConfirmationTitle {
    return Intl.message(
      'Are you sure?',
      name: 'signOutConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Confirm that you really want to leave this super awesome app`
  String get signOutConfirmationMessage {
    return Intl.message(
      'Confirm that you really want to leave this super awesome app',
      name: 'signOutConfirmationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOutConfirmButton {
    return Intl.message(
      'Sign Out',
      name: 'signOutConfirmButton',
      desc: '',
      args: [],
    );
  }

  /// `Stay!`
  String get signOutCancelButton {
    return Intl.message(
      'Stay!',
      name: 'signOutCancelButton',
      desc: '',
      args: [],
    );
  }

  /// `Nobody is here`
  String get noPeople {
    return Intl.message(
      'Nobody is here',
      name: 'noPeople',
      desc: '',
      args: [],
    );
  }

  /// `Error: %s`
  String get error {
    return Intl.message(
      'Error: %s',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `From: %s`
  String get from {
    return Intl.message(
      'From: %s',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get generalError {
    return Intl.message(
      'Something went wrong',
      name: 'generalError',
      desc: '',
      args: [],
    );
  }

  /// `Hasn't received any achievements yet`
  String get receivedNoAchievements {
    return Intl.message(
      'Hasn\'t received any achievements yet',
      name: 'receivedNoAchievements',
      desc: '',
      args: [],
    );
  }

  /// `Received achievements: %i`
  String get receivedAchievements {
    return Intl.message(
      'Received achievements: %i',
      name: 'receivedAchievements',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTabName {
    return Intl.message(
      'Profile',
      name: 'profileTabName',
      desc: '',
      args: [],
    );
  }

  /// `Teams`
  String get teamsTabName {
    return Intl.message(
      'Teams',
      name: 'teamsTabName',
      desc: '',
      args: [],
    );
  }

  /// `People`
  String get peopleTabName {
    return Intl.message(
      'People',
      name: 'peopleTabName',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get achievementsTabName {
    return Intl.message(
      'Library',
      name: 'achievementsTabName',
      desc: '',
      args: [],
    );
  }

  /// `Softeq`
  String get softeq {
    return Intl.message(
      'Softeq',
      name: 'softeq',
      desc: '',
      args: [],
    );
  }

  /// `%i of %i people`
  String get people_progress {
    return Intl.message(
      '%i of %i people',
      name: 'people_progress',
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