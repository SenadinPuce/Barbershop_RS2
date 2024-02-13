import 'dart:convert';

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

String? formatDate(DateTime? value) {
  if (value != null) return DateFormat('dd MMM yyyy').format(value).toString();
  return null;
}
