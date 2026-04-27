import 'package:intl/intl.dart';

class Formatters {
  static String price(double amount, {String currency = 'JOD'}) {
    return '${amount.toStringAsFixed(2)} $currency';
  }

  static String date(DateTime date, {String locale = 'ar'}) {
    return DateFormat.yMMMd(locale).format(date);
  }

  static String time(DateTime date, {String locale = 'ar'}) {
    return DateFormat.jm(locale).format(date);
  }

  static String dateTime(DateTime date, {String locale = 'ar'}) {
    return '${Formatters.date(date, locale: locale)} - ${Formatters.time(date, locale: locale)}';
  }

  static String phone(String phone) {
    if (phone.length == 13) {
      return '${phone.substring(0, 4)} ${phone.substring(4, 6)} ${phone.substring(6, 9)} ${phone.substring(9)}';
    }
    return phone;
  }

  static String rating(double rating) {
    return rating.toStringAsFixed(1);
  }

  static String seatCount(int count) {
    if (count == 1) return 'مقعد واحد';
    if (count == 2) return 'مقعدان';
    if (count >= 3 && count <= 10) return '$count مقاعد';
    return '$count مقعد';
  }
}
