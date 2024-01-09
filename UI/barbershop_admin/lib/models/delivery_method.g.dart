// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryMethod _$DeliveryMethodFromJson(Map<String, dynamic> json) =>
    DeliveryMethod(
      id: json['id'] as int?,
      shortName: json['shortName'] as String?,
      deliveryTime: json['deliveryTime'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DeliveryMethodToJson(DeliveryMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shortName': instance.shortName,
      'deliveryTime': instance.deliveryTime,
      'description': instance.description,
      'price': instance.price,
    };
