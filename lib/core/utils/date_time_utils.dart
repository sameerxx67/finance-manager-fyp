class DateTimeUtils {
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);

  // add (DateTime.now().weekday - 1 if you want week start from mon)
  static DateTime startOfWeek() => startOfDay(
    DateTime.now().subtract(Duration(days: DateTime.now().weekday)),
  );

  static DateTime endOfWeek() => endOfDay(startOfWeek().add(Duration(days: 6)));
}
