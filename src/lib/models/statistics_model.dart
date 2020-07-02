class StatisticsModel {
  final String title;
  final int allUsersCount;
  final int positiveUsersCount;
  final double ratioValue;

  StatisticsModel(this.title, this.allUsersCount, this.positiveUsersCount)
      : ratioValue =
            allUsersCount == 0 ? 0 : positiveUsersCount / allUsersCount;

  StatisticsModel.empty(String title) : this(title, 0, 0);
}
