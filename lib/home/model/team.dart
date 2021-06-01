import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable(explicitToJson: true)
class Team {
  Team();

  @JsonKey(name: 'team_id')
  int? teamId;
  double? rating;
  int? wins;
  int? losses;
  @JsonKey(name: 'last_match_time')
  int? lastMatchTime;
  String? name;
  String? tag;
  @JsonKey(name: 'logo_url')
  String? logoUrl;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
