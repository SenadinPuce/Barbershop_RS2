import 'package:json_annotation/json_annotation.dart';

part 'term.g.dart';

@JsonSerializable()
class Term {
  int? id;
  int? barberId;
  String? barberName;
  DateTime? date;
  String? startTime; 
  String? endTime; 
  bool? isBooked;
  bool? isCanceled;

  Term({
    this.id,
    this.barberId,
    this.barberName,
    this.date,
    this.startTime,
    this.endTime,
    this.isBooked,
    this.isCanceled
  });

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);

  Map<String, dynamic> toJson() => _$TermToJson(this);
}
