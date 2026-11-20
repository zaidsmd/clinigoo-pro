import 'package:intl/intl.dart';

abstract final class DateTimeUtils {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  static String formatDate(DateTime date) => _dateFormat.format(date);

  static String toApiDate(DateTime date) => _apiDateFormat.format(date);

  static DateTime? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      try {
        return _dateFormat.parse(value);
      } catch (_) {
        return null;
      }
    }
  }
}
