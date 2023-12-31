import 'package:json_annotation/json_annotation.dart';

import 'photo.dart';

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
  List<Photo>? photos;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.pictureUrl,
      this.productType,
      this.productBrand,
      this.photos});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
