// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable()
class Service {
  int? id;
  String? name;
  String? description;
  double? price;
  int? durationInMinutes;

  Service({
    this.id,
    this.name,
    this.description,
    this.price,
    this.durationInMinutes
  });

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
