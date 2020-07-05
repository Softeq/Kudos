class StatisticsModel {
  String _title;

  int allUsersCount;
  int positiveUsersCount;

  String get title => _title;
  double get ratio => allUsersCount == 0 ? 0 : positiveUsersCount / allUsersCount;

  StatisticsModel(this._title, this.allUsersCount, this.positiveUsersCount);
  StatisticsModel.empty(String title) : this(title, 0, 0);
}
