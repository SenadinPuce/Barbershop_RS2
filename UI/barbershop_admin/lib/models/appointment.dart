// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'service.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  int? id;
  DateTime? startTime;
  DateTime? endTime;
  String? status;
  int? barberId;
  String? barberFullName;
  int? clientId;
  String? clientFullName;
  List<Service>? services;

  Appointment({
    this.id,
    this.startTime,
    this.endTime,
    this.status,
    this.barberId,
    this.barberFullName,
    this.clientId,
    this.clientFullName,
    this.services,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
