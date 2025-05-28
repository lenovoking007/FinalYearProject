import 'package:intl/intl.dart';

class DateFormatter {
  static String formatApiDate(String apiDate) {
    try {
      final parsedDate = DateFormat("E, d MMM y H:m:s Z").parse(apiDate);
      return "Last Update: ${DateFormat.yMMMd().add_jm().format(parsedDate)}";
    } catch (e) {
      return "Last Update: N/A";
    }
  }
}