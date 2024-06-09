import 'package:json_annotation/json_annotation.dart';

import 'address.dart';
import 'delivery_method.dart';
import 'order_item.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  int? id;
  String? orderNumber;
  String? clientUsername;
  String? clientEmail;
  String? clientPhoneNumber;
  DateTime? orderDate;
  Address? address;
  DeliveryMethod? deliveryMethod;
  List<OrderItem>? orderItems;
  double? subtotal;
  double? total;
  String? status;

  Order({
    this.id,
    this.orderNumber,
    this.clientUsername,
    this.clientEmail,
    this.clientPhoneNumber,
    this.orderDate,
    this.address,
    this.deliveryMethod,
    this.orderItems,
    this.subtotal,
    this.total,
    this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}