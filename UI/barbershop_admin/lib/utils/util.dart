import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Authorization {
  static String? username;
  static String? email;
  static String? token;
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(
    base64Decode(base64Image),
    fit: BoxFit.contain,
  );
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

String formatTime(TimeOfDay? date) {
  return date != null
      ? DateFormat('h:mm a').format(DateTime(
          2000,
          1,
          1,
          date.hour,
          date.minute,
        ))
      : "Select a time";
}
