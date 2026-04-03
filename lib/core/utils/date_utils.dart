import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String formatDayOfWeek(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String formatDayOfWeekFull(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateOnly).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return formatDayOfWeekFull(date);
    return formatDate(date);
  }

  static DateTime get startOfWeek {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - (now.weekday - 1));
  }

  static DateTime get endOfWeek {
    final start = startOfWeek;
    return start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  static DateTime get startOfLastWeek {
    return startOfWeek.subtract(const Duration(days: 7));
  }

  static DateTime get endOfLastWeek {
    return startOfWeek.subtract(const Duration(seconds: 1));
  }

  static DateTime get startOfMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  static DateTime get endOfMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  }

  static DateTime get startOfLastMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month - 1, 1);
  }

  static DateTime get endOfLastMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 0, 23, 59, 59);
  }

  static int daysRemaining(DateTime deadline) {
    final now = DateTime.now();
    return deadline.difference(now).inDays;
  }

  static List<DateTime> getDaysInCurrentWeek() {
    final start = startOfWeek;
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  static List<DateTime> getDaysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    return List.generate(
      last.day,
      (i) => first.add(Duration(days: i)),
    );
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isThisWeek(DateTime date) {
    return date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(seconds: 1)));
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}
