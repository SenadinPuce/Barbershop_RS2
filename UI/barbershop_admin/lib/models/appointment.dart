import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  int? id;
  int? clientId;
  String? clientName;
  int? termId;
  DateTime? date;
  String? startTime;
  String? endTime;
  int? serviceId;
  String? serviceName;
  double? servicePrice;
  DateTime? reservationDate;
  bool? isCanceled;

  Appointment({
    this.id,
    this.clientId,
    this.clientName,
    this.termId,
    this.date,
    this.startTime,
    this.endTime,
    this.serviceId,
    this.serviceName,
    this.servicePrice,
    this.reservationDate,
    this.isCanceled,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}