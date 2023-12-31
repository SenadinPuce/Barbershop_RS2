import 'package:json_annotation/json_annotation.dart';


part 'photo.g.dart';

@JsonSerializable()
class Photo {
  int? id;
  String? pictureUrl;
  String? fileName;
  bool? isMain;

  Photo({this.id, this.pictureUrl, this.fileName, this.isMain});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
