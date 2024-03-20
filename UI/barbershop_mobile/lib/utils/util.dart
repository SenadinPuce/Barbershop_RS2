import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Authorization {
  static int? id;
  static String? username;
  static String? email;
  static String? token;
}

class ButtomNavigationBarHelper {
  static int currentIndex = 0;
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(
    base64Decode(base64Image),
    fit: BoxFit.contain,
  );
}

String? formatDate(DateTime? value) {
  if (value != null) return DateFormat('dd MMM yyyy').format(value).toString();
  return null;
}

String? formatTime(DateTime? value) {
  if (value != null) return DateFormat('HH:mm').format(value).toString();
  return null;
}

String formatNumber(dynamic value) {
  var f = NumberFormat('###,##0.00');

  if (value == null) {
    return "";
  }
  return f.format(value);
}
