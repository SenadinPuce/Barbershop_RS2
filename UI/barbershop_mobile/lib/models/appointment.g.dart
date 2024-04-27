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
      barberFullName: json['barberFullName'] as String?,
      clientId: json['clientId'] as int?,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'durationInMinutes': instance.durationInMinutes,
      'status': instance.status,
      'barberId': instance.barberId,
      'barberFullName': instance.barberFullName,
      'clientId': instance.clientId,
      'services': instance.services,
    };
