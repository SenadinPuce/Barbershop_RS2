import 'package:json_annotation/json_annotation.dart';

part 'brand.g.dart';

@JsonSerializable()
class ProductBrand {
  int? id;
  String? name;

  ProductBrand({this.id, this.name});

  factory ProductBrand.fromJson(Map<String, dynamic> json) =>
      _$ProductBrandFromJson(json);

  Map<String, dynamic> toJson() => _$ProductBrandToJson(this);
}