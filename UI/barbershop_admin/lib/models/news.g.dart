// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      id: json['id'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      photo: json['photo'] as String?,
      createdDateTime: json['createdDateTime'] == null
          ? null
          : DateTime.parse(json['createdDateTime'] as String),
      authorId: json['authorId'] as int?,
      authorFullName: json['authorFullName'] as String?,
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'photo': instance.photo,
      'createdDateTime': instance.createdDateTime?.toIso8601String(),
      'authorId': instance.authorId,
      'authorFullName': instance.authorFullName,
    };
