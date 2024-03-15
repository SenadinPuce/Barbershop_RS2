import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  int? id;
  String? name;
  String? description;
  double? price;
  String? pictureUrl;
  String? productType;
  String? productBrand;
  String? photo;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.pictureUrl,
      this.productType,
      this.productBrand,
      this.photo});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
