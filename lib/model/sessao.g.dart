// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sessao _$SessaoFromJson(Map json) {
  return Sessao(
    id: json['id'] as String,
    titulo: json['titulo'] as String,
    data: json['data'] == null ? null : DateTime.parse(json['data'] as String),
    aventura: json['aventura'] == null
        ? null
        : Adventure.fromJson(json['aventura'] as Map),
  );
}

Map<String, dynamic> _$SessaoToJson(Sessao instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('titulo', instance.titulo);
  writeNotNull('data', instance.data?.toIso8601String());
  writeNotNull('aventura', instance.aventura?.toJson());
  return val;
}
