
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
  int? clientId;
  String? clientUsername;
  int? serviceId;
  String? serviceName;

  Appointment(
      {this.id,
      this.startTime,
      this.endTime,
      this.durationInMinutes,
      this.status,
      this.barberId,
      this.barberUsername,
      this.clientId,
      this.clientUsername,
      this.serviceId,
      this.serviceName});

    factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

     Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
