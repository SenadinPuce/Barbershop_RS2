import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  int? id;
  DateTime? startTime;
  DateTime? endTime;
  int? durationInMinutes;
  String? status;
  int? barberId;
  String? barberUsername;
  String? barberFullName;
  int? clientId;
  String? clientUsername;
  String? clientFullName;
  int? serviceId;
  String? serviceName;
  double? servicePrice;

  Appointment(
      {this.id,
      this.startTime,
      this.endTime,
      this.durationInMinutes,
      this.status,
      this.barberId,
      this.barberUsername,
      this.barberFullName,
      this.clientId,
      this.clientUsername,
      this.clientFullName,
      this.serviceId,
      this.serviceName,
      this.servicePrice});

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
