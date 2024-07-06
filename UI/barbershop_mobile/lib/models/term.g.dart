// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Term _$TermFromJson(Map<String, dynamic> json) => Term(
      id: json['id'] as int?,
      barberId: json['barberId'] as int?,
      barberName: json['barberName'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      isBooked: json['isBooked'] as bool?,
    );

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'id': instance.id,
      'barberId': instance.barberId,
      'barberName': instance.barberName,
      'date': instance.date?.toIso8601String(),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isBooked': instance.isBooked,
    };
