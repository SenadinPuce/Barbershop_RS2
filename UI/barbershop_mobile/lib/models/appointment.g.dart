// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      id: json['id'] as int?,
      clientId: json['clientId'] as int?,
      clientName: json['clientName'] as String?,
      barberName: json['barberName'] as String?,
      termId: json['termId'] as int?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      serviceId: json['serviceId'] as int?,
      serviceName: json['serviceName'] as String?,
      servicePrice: (json['servicePrice'] as num?)?.toDouble(),
      reservationDate: json['reservationDate'] == null
          ? null
          : DateTime.parse(json['reservationDate'] as String),
      isCanceled: json['isCanceled'] as bool?,
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'barberName': instance.barberName,
      'termId': instance.termId,
      'date': instance.date?.toIso8601String(),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'servicePrice': instance.servicePrice,
      'reservationDate': instance.reservationDate?.toIso8601String(),
      'isCanceled': instance.isCanceled,
    };
