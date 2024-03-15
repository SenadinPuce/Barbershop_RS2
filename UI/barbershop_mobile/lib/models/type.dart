import 'package:json_annotation/json_annotation.dart';

part 'type.g.dart';

@JsonSerializable()
class ProductType {
  int? id;
  String? name;

  ProductType({this.id, this.name});

  factory ProductType.fromJson(Map<String, dynamic> json) =>
      _$ProductTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ProductTypeToJson(this);
}