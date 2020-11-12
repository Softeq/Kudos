// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "accessDenied" : MessageLookupByLibrary.simpleMessage("Доступ запрещён"),
    "accessLevel" : MessageLookupByLibrary.simpleMessage("Уровень доступа"),
    "accessLevelPrivate" : MessageLookupByLibrary.simpleMessage("Частная"),
    "accessLevelPrivateDescription" : MessageLookupByLibrary.simpleMessage("Награды частных команд видны только участникам этой команды"),
    "accessLevelProtected" : MessageLookupByLibrary.simpleMessage("Защищенная"),
    "accessLevelProtectedDescription" : MessageLookupByLibrary.simpleMessage("Награды защищенных команд видны всем пользователям, но они не могут их дарить"),
    "accessLevelPublic" : MessageLookupByLibrary.simpleMessage("Публичная"),
    "accessLevelPublicDescription" : MessageLookupByLibrary.simpleMessage("Все пользователи могут видеть и дарить награды публичных команд"),
    "achievementHoldersEmptyPlaceholder" : MessageLookupByLibrary.simpleMessage("Никто ещё не получал эту награду"),
    "achievementHoldersTitle" : MessageLookupByLibrary.simpleMessage("Обладатели"),
    "achievementOwnerTitle" : MessageLookupByLibrary.simpleMessage("Владелец"),
    "achievementStatisticsTitle" : MessageLookupByLibrary.simpleMessage("Общий Прогресс"),
    "achievements" : MessageLookupByLibrary.simpleMessage("Достижения"),
    "achievementsTabName" : MessageLookupByLibrary.simpleMessage("Награды"),
    "addPeople" : MessageLookupByLibrary.simpleMessage("Добавить людей"),
    "admins" : MessageLookupByLibrary.simpleMessage("Администраторы"),
    "appName" : MessageLookupByLibrary.simpleMessage("Kudos"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Отмена"),
    "cannotBeSentMessage" : MessageLookupByLibrary.simpleMessage("Кудос из приватной команды может быть послан только членам этой команды.\n\nДобавьте людей в команду и повторите попытку снова."),
    "cannotBeSentTitle" : MessageLookupByLibrary.simpleMessage("Кудос не может быть отправлен"),
    "create" : MessageLookupByLibrary.simpleMessage("Создать"),
    "createTeam" : MessageLookupByLibrary.simpleMessage("Создать команду"),
    "createYourOwnAchievements" : MessageLookupByLibrary.simpleMessage("Создавайте свои собственные награды и дарите их своим коллегам!"),
    "createYourOwnTeams" : MessageLookupByLibrary.simpleMessage("Создавайте свои команды и приглашайте в них своих коллег!"),
    "delete" : MessageLookupByLibrary.simpleMessage("Удалить"),
    "deleteAchievementWarning" : MessageLookupByLibrary.simpleMessage("Вы действительно хотите удалить эту награду?"),
    "deleteTeamWarning" : MessageLookupByLibrary.simpleMessage("Вы действительно хотите удалить эту команду? Все награды этой команды будут также удалены"),
    "description" : MessageLookupByLibrary.simpleMessage("Описание"),
    "descriptionIsNullErrorMessage" : MessageLookupByLibrary.simpleMessage("Добавьте описание"),
    "detailedError" : MessageLookupByLibrary.simpleMessage("Ошибка: %s"),
    "edit" : MessageLookupByLibrary.simpleMessage("Редактировать"),
    "editDescription" : MessageLookupByLibrary.simpleMessage("Сделай описание значимым"),
    "editImage" : MessageLookupByLibrary.simpleMessage("Сделай изображение узнаваемым"),
    "editName" : MessageLookupByLibrary.simpleMessage("Сделай название уникальным"),
    "editTeam" : MessageLookupByLibrary.simpleMessage("Редактировать команду"),
    "enterName" : MessageLookupByLibrary.simpleMessage("Введите имя"),
    "error" : MessageLookupByLibrary.simpleMessage("Ошибка"),
    "fileIsNullErrorMessage" : MessageLookupByLibrary.simpleMessage("Добавьте картинку"),
    "fileSizeTooBig" : MessageLookupByLibrary.simpleMessage("Размер изображения должен быть меньше 0.5Mb"),
    "from" : MessageLookupByLibrary.simpleMessage("От: %s"),
    "generalErrorMessage" : MessageLookupByLibrary.simpleMessage("Что-то пошло не так"),
    "members" : MessageLookupByLibrary.simpleMessage("Состав"),
    "myAchievements" : MessageLookupByLibrary.simpleMessage("Mои Награды"),
    "myTeams" : MessageLookupByLibrary.simpleMessage("Мои Команды"),
    "name" : MessageLookupByLibrary.simpleMessage("Название"),
    "nameIsNullErrorMessage" : MessageLookupByLibrary.simpleMessage("Добавьте название"),
    "noComment" : MessageLookupByLibrary.simpleMessage("Нет комментария"),
    "notSignedIn" : MessageLookupByLibrary.simpleMessage("Войдите, чтобы увидеть свои награды"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "otherTeams" : MessageLookupByLibrary.simpleMessage("Другие Команды"),
    "people" : MessageLookupByLibrary.simpleMessage("Люди"),
    "peopleProgress" : MessageLookupByLibrary.simpleMessage("%i из %i людей"),
    "peopleTabName" : MessageLookupByLibrary.simpleMessage("Люди"),
    "privateTeam" : MessageLookupByLibrary.simpleMessage("Это частная команда"),
    "profileAchievementsEmptyPlaceholder" : MessageLookupByLibrary.simpleMessage("Ещё нет наград"),
    "profileTabName" : MessageLookupByLibrary.simpleMessage("Кабинет"),
    "receivedAchievements" : MessageLookupByLibrary.simpleMessage("Получено наград: %i"),
    "requiredField" : MessageLookupByLibrary.simpleMessage("Обязательное поле"),
    "save" : MessageLookupByLibrary.simpleMessage("Сохранить"),
    "search" : MessageLookupByLibrary.simpleMessage("Поиск"),
    "searchAdmins" : MessageLookupByLibrary.simpleMessage("Искать администраторов"),
    "searchEmptyPlaceholder" : MessageLookupByLibrary.simpleMessage("Нет результатов поиска"),
    "searchMembers" : MessageLookupByLibrary.simpleMessage("Искать участников"),
    "send" : MessageLookupByLibrary.simpleMessage("Отправить"),
    "signIn" : MessageLookupByLibrary.simpleMessage("Войти через Google"),
    "signOutCancelButton" : MessageLookupByLibrary.simpleMessage("Остаться!"),
    "signOutConfirmButton" : MessageLookupByLibrary.simpleMessage("Выйти"),
    "signOutConfirmationMessage" : MessageLookupByLibrary.simpleMessage("Подтвердите, что вы действительно хотите выйти из этого превосходного приложения"),
    "signOutConfirmationTitle" : MessageLookupByLibrary.simpleMessage("Вы уверены?"),
    "softeq" : MessageLookupByLibrary.simpleMessage("Softeq"),
    "team" : MessageLookupByLibrary.simpleMessage("Команда"),
    "teamDescriptionPlaceholder" : MessageLookupByLibrary.simpleMessage("Введите описание команды"),
    "teamMemberPickerEmptyMessage" : MessageLookupByLibrary.simpleMessage("Выберите хотя бы одного администратора"),
    "teamNameExists" : MessageLookupByLibrary.simpleMessage("Команда с таким названием уже существует. Измените название и попробуйте еще раз"),
    "teamNamePlaceholder" : MessageLookupByLibrary.simpleMessage("Введите название команды"),
    "teams" : MessageLookupByLibrary.simpleMessage("Команды"),
    "teamsTabName" : MessageLookupByLibrary.simpleMessage("Команды"),
    "transferAchievementDescription" : MessageLookupByLibrary.simpleMessage("Вы хотите сменить владельца текущей награды на другого пользователя или другую команду?"),
    "transferAchievementTitle" : MessageLookupByLibrary.simpleMessage("Сменить владельца"),
    "transferAchievementToTeamTitle" : MessageLookupByLibrary.simpleMessage("Сменить владельца на команду %s?"),
    "transferAchievementToTeamWarning" : MessageLookupByLibrary.simpleMessage("Вы можете потерять доступ к этой награде после завершения данной операции"),
    "transferAchievementToUserTitle" : MessageLookupByLibrary.simpleMessage("Сменить владельца на %s?"),
    "transferAchievementToUserWarning" : MessageLookupByLibrary.simpleMessage("Вы потеряете доступ к этой награде после завершения данной операции"),
    "updateRequired" : MessageLookupByLibrary.simpleMessage("Требуется Обновление"),
    "updateRequiredMessage" : MessageLookupByLibrary.simpleMessage("Пожалуйста обновите свое приложение до последней версии."),
    "user" : MessageLookupByLibrary.simpleMessage("Пользователь"),
    "userPickerEmptyMessage" : MessageLookupByLibrary.simpleMessage("Выберите хотя бы одного пользователя"),
    "userTeamsEmptyPlaceholder" : MessageLookupByLibrary.simpleMessage("Этот пользователь пока не состоит ни в одной команде"),
    "warning" : MessageLookupByLibrary.simpleMessage("Внимание"),
    "writeAComment" : MessageLookupByLibrary.simpleMessage("Ваш комментарий"),
    "youLabel" : MessageLookupByLibrary.simpleMessage("(вы)")
  };
}
