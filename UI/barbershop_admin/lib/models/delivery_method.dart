import 'package:json_annotation/json_annotation.dart';

part 'delivery_method.g.dart';

@JsonSerializable()
class DeliveryMethod {
  int? id;
  String? shortName;
  String? deliveryTime;
  String? description;
  double? price;
  DeliveryMethod({
    this.id,
    this.shortName,
    this.deliveryTime,
    this.description,
    this.price,
  });

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) =>
      _$DeliveryMethodFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryMethodToJson(this);
}
