// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerPayment _$CustomerPaymentFromJson(Map<String, dynamic> json) =>
    CustomerPayment()
      ..clientSecret = json['clientSecret'] as String?
      ..paymentIntentId = json['paymentIntentId'] as String?;

Map<String, dynamic> _$CustomerPaymentToJson(CustomerPayment instance) =>
    <String, dynamic>{
      'clientSecret': instance.clientSecret,
      'paymentIntentId': instance.paymentIntentId,
    };
