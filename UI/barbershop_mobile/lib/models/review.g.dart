// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      id: json['id'] as int?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
      userId: json['userId'] as int?,
      createdDateTime: json['createdDateTime'] == null
          ? null
          : DateTime.parse(json['createdDateTime'] as String),
    )
      ..clientFirstName = json['clientFirstName'] as String?
      ..clientLastName = json['clientLastName'] as String?;

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
      'userId': instance.userId,
      'clientFirstName': instance.clientFirstName,
      'clientLastName': instance.clientLastName,
      'createdDateTime': instance.createdDateTime?.toIso8601String(),
    };
