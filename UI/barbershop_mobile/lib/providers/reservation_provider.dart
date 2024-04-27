import 'package:barbershop_mobile/models/service.dart';
import 'package:flutter/material.dart';

class ReservationProvider with ChangeNotifier {
  int? barberId;
  List<Service>? selectedServices;
  DateTime? startTime;
}
