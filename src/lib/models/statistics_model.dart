class StatisticsModel {
  final String title;

  int allUsersCount;
  int positiveUsersCount;

  double get ratio =>
      allUsersCount == 0 ? 0 : positiveUsersCount / allUsersCount;

  StatisticsModel(this.title, this.allUsersCount, this.positiveUsersCount);
  StatisticsModel.empty(String title) : this(title, 0, 0);
}
