// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  return Team()
    ..teamId = json['team_id'] as int?
    ..rating = (json['rating'] as num?)?.toDouble()
    ..wins = json['wins'] as int?
    ..losses = json['losses'] as int?
    ..lastMatchTime = json['last_match_time'] as int?
    ..name = json['name'] as String?
    ..tag = json['tag'] as String?
    ..logoUrl = json['logo_url'] as String?;
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'team_id': instance.teamId,
      'rating': instance.rating,
      'wins': instance.wins,
      'losses': instance.losses,
      'last_match_time': instance.lastMatchTime,
      'name': instance.name,
      'tag': instance.tag,
      'logo_url': instance.logoUrl,
    };
