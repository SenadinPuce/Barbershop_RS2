// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      pictureUrl: json['pictureUrl'] as String?,
      productType: json['productType'] as String?,
      productBrand: json['productBrand'] as String?,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'pictureUrl': instance.pictureUrl,
      'productType': instance.productType,
      'productBrand': instance.productBrand,
      'photo': instance.photo,
    };