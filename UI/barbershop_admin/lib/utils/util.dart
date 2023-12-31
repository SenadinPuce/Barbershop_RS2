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
