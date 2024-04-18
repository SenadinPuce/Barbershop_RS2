// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      id: json['id'] as int?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      durationInMinutes: json['durationInMinutes'] as int?,
      status: json['status'] as String?,
      barberId: json['barberId'] as int?,
      barberUsername: json['barberUsername'] as String?,
      barberFullName: json['barberFullName'] as String?,
      clientId: json['clientId'] as int?,
      clientUsername: json['clientUsername'] as String?,
      clientFullName: json['clientFullName'] as String?,
      serviceId: json['serviceId'] as int?,
      serviceName: json['serviceName'] as String?,
      servicePrice: (json['servicePrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'durationInMinutes': instance.durationInMinutes,
      'status': instance.status,
      'barberId': instance.barberId,
      'barberUsername': instance.barberUsername,
      'barberFullName': instance.barberFullName,
      'clientId': instance.clientId,
      'clientUsername': instance.clientUsername,
      'clientFullName': instance.clientFullName,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'servicePrice': instance.servicePrice,
    };
