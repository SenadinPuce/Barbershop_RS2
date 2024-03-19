import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  int? id;
  int? rating;
  String? comment;
  int? userId;
  String? clientFirstName;
  String? clientLastName;
  DateTime? createdDateTime;

  Review({
    this.id,
    this.rating,
    this.comment,
    this.userId,
    this.createdDateTime,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
