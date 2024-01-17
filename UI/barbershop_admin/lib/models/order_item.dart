import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  int? id;
  String? productName;
  String? photo;
  double? price;
  int? quantity;
  OrderItem({
    this.id,
    this.productName,
    this.photo,
    this.price,
    this.quantity,
  });

    factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
