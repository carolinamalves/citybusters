class PUDateTime {
  static int getTimeDifference(DateTime _d) {
    final now = DateTime.now();
    final __d = _d.toLocal();
    final dForm = DateTime(__d.year, __d.month, __d.day);

    return dForm.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  static isLastWeek(DateTime _d) => getTimeDifference(_d) >= -7;
  static isYesterday(DateTime _d) => getTimeDifference(_d) == -1;
  static isToday(DateTime _d) => getTimeDifference(_d) == 0;
  static isTommorrow(DateTime _d) => getTimeDifference(_d) == 1;
  static isThisWeek(DateTime _d) => getTimeDifference(_d) <= 7;
}
