import 'package:igor_app/model/adventure.dart';
import 'package:igor_app/model/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sessao.g.dart';

@JsonSerializable(
    explicitToJson: true, createToJson: true, createFactory: true, anyMap: true)
class Sessao implements IEntity<Adventure> {

  static String collectionName = "sessions";
  factory Sessao.fromJson(Map<dynamic, dynamic> json) =>
      _$SessaoFromJson(json);
  Map<dynamic, dynamic> toJson() => _$SessaoToJson(this);

  Sessao({this.id, this.titulo, this.data, this.aventura});

  @JsonKey(includeIfNull: false, nullable: true)
  String id;

  @JsonKey(includeIfNull: false)
  String titulo;

  @JsonKey(includeIfNull: false)
  DateTime data;

  @JsonKey(includeIfNull: false)
  Adventure aventura;

  @override
  fromJson(Map json) => _$SessaoFromJson(json);

  @override
  String getCollectionName() => Sessao.collectionName;

  @override
  String getId() => id;
}