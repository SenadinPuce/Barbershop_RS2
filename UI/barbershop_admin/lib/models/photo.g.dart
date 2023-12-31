// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      id: json['id'] as int?,
      pictureUrl: json['pictureUrl'] as String?,
      fileName: json['fileName'] as String?,
      isMain: json['isMain'] as bool?,
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'pictureUrl': instance.pictureUrl,
      'fileName': instance.fileName,
      'isMain': instance.isMain,
    };
