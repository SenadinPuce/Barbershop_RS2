import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  int? id;
  String? title;
  String? content;
  String? photo;
  DateTime? createdDateTime;
  int? authorId;

  News({
    this.id,
    this.title,
    this.content,
    this.photo,
    this.createdDateTime,
    this.authorId,
  });

  factory News.fromJson(Map<String, dynamic> json) =>
      _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
