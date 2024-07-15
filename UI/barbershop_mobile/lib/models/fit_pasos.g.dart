// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fit_pasos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FITPasos _$FITPasosFromJson(Map<String, dynamic> json) => FITPasos(
      id: json['id'] as int?,
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      datumVazenja: json['datumVazenja'] == null
          ? null
          : DateTime.parse(json['datumVazenja'] as String),
      isValid: json['isValid'] as bool?,
    );

Map<String, dynamic> _$FITPasosToJson(FITPasos instance) => <String, dynamic>{
      'id': instance.id,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'datumVazenja': instance.datumVazenja?.toIso8601String(),
      'isValid': instance.isValid,
    };
