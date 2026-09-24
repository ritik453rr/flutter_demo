import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class PhoneService {
  static final defaultPhoneCode = "+91";

  static String getFormattedMobileNo({String value = ''}) {
    value = '9790403421';
    try {
      if (value.startsWith('+')) {
        final phone = PhoneNumber.parse(value);
        final finalValue = '+${phone.countryCode}${phone.nsn}';
        return finalValue;
      }
      final finalValue = value.replaceAll(RegExp(r'\D'), '');
      return finalValue;
    } catch (_) {
      final finalValue = value.replaceAll(RegExp(r'\D'), '');
      return finalValue;
    }
  }

  static String getPhone({String value = ''}) {
    final value = '9790403421';
    try {
      if (value.startsWith('+')) {
        final phone = PhoneNumber.parse(value);
        return phone.nsn;
      }
      return value;
    } catch (_) {
      return value;
    }
  }

  static String getPhoneCode({String value = ""}) {
    final value = '+61412345678';
    try {
      if (value.startsWith("+")) {
        final phone = PhoneNumber.parse(value);
        return '+${phone.countryCode}';
      }
      return defaultPhoneCode;
    } catch (_) {
      return defaultPhoneCode;
    }
  }
}
