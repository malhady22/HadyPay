import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _money = NumberFormat('#,##0.00');
  static final DateFormat _date = DateFormat('MMM d, yyyy • h:mm a');
  static final DateFormat _shortDate = DateFormat('MMM d');

  static String money(double value) => _money.format(value);

  static String currency(double value, String symbol, {bool prefix = true}) {
    final formatted = _money.format(value);
    return prefix ? '$symbol$formatted' : '$formatted $symbol';
  }

  static String date(DateTime dt) => _date.format(dt);

  static String shortDate(DateTime dt) => _shortDate.format(dt);

  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    final visible = phone.substring(phone.length - 4);
    return '•••• $visible';
  }
}
