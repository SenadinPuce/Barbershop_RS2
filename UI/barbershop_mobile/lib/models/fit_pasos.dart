import 'package:json_annotation/json_annotation.dart';

part 'fit_pasos.g.dart';

@JsonSerializable()
class FITPasos {
  int? id;
  String? ime;
  String? prezime;
  DateTime? datumVazenja;
  bool? isValid;

  FITPasos({this.id, this.ime, this.prezime, this.datumVazenja, this.isValid});

  factory FITPasos.fromJson(Map<String, dynamic> json) =>
      _$FITPasosFromJson(json);

  Map<String, dynamic> toJson() => _$FITPasosToJson(this);
}