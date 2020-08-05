// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adventure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Adventure _$AdventureFromJson(Map json) {
  return Adventure(
    id: json['id'] as String,
    title: json['title'] as String,
    textBody: json['textBody'] as String,
  )
    ..ownerPlayer = json['ownerPlayer'] == null
        ? null
        : Player.fromJson(json['ownerPlayer'] as Map)
    ..players = (json['players'] as List)
        ?.map((e) => e == null ? null : Player.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$AdventureToJson(Adventure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('textBody', instance.textBody);
  writeNotNull('ownerPlayer', instance.ownerPlayer?.toJson());
  writeNotNull('players', instance.players?.map((e) => e?.toJson())?.toList());
  return val;
}
