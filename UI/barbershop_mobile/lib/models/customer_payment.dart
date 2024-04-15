// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'customer_payment.g.dart';

@JsonSerializable()
class CustomerPayment {
  String? clientSecret;
  String? paymentIntentId;
  
  CustomerPayment({
    this.clientSecret,
    this.paymentIntentId,
  });

  factory CustomerPayment.fromJson(Map<String, dynamic> json) =>
      _$CustomerPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerPaymentToJson(this);
}
