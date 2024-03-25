// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as int?,
      clientUsername: json['clientUsername'] as String?,
      clientEmail: json['clientEmail'] as String?,
      clientPhoneNumber: json['clientPhoneNumber'] as String?,
      orderDate: json['orderDate'] == null
          ? null
          : DateTime.parse(json['orderDate'] as String),
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      deliveryMethod: json['deliveryMethod'] == null
          ? null
          : DeliveryMethod.fromJson(
              json['deliveryMethod'] as Map<String, dynamic>),
      orderItems: (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'clientUsername': instance.clientUsername,
      'clientEmail': instance.clientEmail,
      'clientPhoneNumber': instance.clientPhoneNumber,
      'orderDate': instance.orderDate?.toIso8601String(),
      'address': instance.address,
      'deliveryMethod': instance.deliveryMethod,
      'orderItems': instance.orderItems,
      'subtotal': instance.subtotal,
      'total': instance.total,
      'status': instance.status,
    };