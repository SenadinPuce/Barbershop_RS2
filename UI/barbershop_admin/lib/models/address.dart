import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  String? firstName;
  String? lastName;
  String? street;
  String? city;
  String? state;
  String? zipCode;
  Address({
    this.firstName,
    this.lastName,
    this.street,
    this.city,
    this.state,
    this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
