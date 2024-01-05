import 'dart:core';

import 'package:intl/intl.dart';

class Authorization {
  static String? username;
  static String? email;
  static String? token;
}

String formatNumber(dynamic value) {
  var f = NumberFormat('###,##0.00');

  if (value == null) {
    return "";
  }
  return f.format(value);
}

String getDate(DateTime? value) {
  return value != null
      ? DateFormat('dd MMM yyyy').format(value).toString()
      : " ";
}

String getTime(DateTime? value) {
  return "${value?.hour}:${value?.minute}";
}

String formatDate(DateTime? date) {
  return date != null
      ? DateFormat('dd MMM yyyy').format(date)
      : "Select a date";
}
