import 'package:intl/intl.dart';

class AppDateTimeFormatService {
  // take date and return in this format: 26 July 2026
  static String fomatToDayMonthYear(String value) {
    if (value.isEmpty) return "";
    final date = DateTime.parse(value).toLocal();
    return DateFormat("d MMMM yyyy").format(date);
  }

  static String formatToDayMonthYear(String value) => fomatToDayMonthYear(value);

  // take date and return formatted time e.g. 10:30 AM
  static String formatToTime(String value) {
    if (value.isEmpty) return "";
    final date = DateTime.parse(value).toLocal();
    return DateFormat("hh:mm a").format(date);
  }
}

