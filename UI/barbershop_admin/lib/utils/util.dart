import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Authorization {
  static int? id;
  static String? username;
  static String? email;
  static String? token;
}

String toTitleCase(String text) {
  if (text.isEmpty) return '';
  return text.toLowerCase().split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1);
    } else {
      return '';
    }
  }).join(' ');
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(base64Decode(base64Image), fit: BoxFit.fill, gaplessPlayback: true,);
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
  if (value == null) return '';

  final format = DateFormat('h:mm');

  return format.format(value);
}

String formatDate(DateTime? date) {
  return date != null
      ? DateFormat('dd MMM yyyy').format(date)
      : "Select a date";
}

String? formatTime(DateTime? value) {
  if (value != null) return DateFormat('HH:mm').format(value).toString();
  return null;
}
