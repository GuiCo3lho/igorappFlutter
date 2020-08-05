// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map json) {
  return Player(
    id: json['id'] as String,
    name: json['name'] as String,
  )
    ..email = json['email'] as String
    ..password = json['password'] as String
    ..invites = (json['invites'] as List)
        ?.map((e) => e == null ? null : Adventure.fromJson(e as Map))
        ?.toList()
    ..adventures = (json['adventures'] as List)
        ?.map((e) => e == null ? null : Adventure.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$PlayerToJson(Player instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('invites', instance.invites?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'adventures', instance.adventures?.map((e) => e?.toJson())?.toList());
  return val;
}
