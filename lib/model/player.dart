import 'package:igor_app/model/adventure.dart';
import 'package:igor_app/model/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable(
    explicitToJson: true, createToJson: true, createFactory: true, anyMap: true)
class Player implements IEntity<Player> {
  static String collectionName = "users";
  factory Player.fromJson(Map<dynamic, dynamic> json) => _$PlayerFromJson(json);
  Map<dynamic, dynamic> toJson() => _$PlayerToJson(this);

  Player({this.id, this.name});

  @JsonKey(includeIfNull: false, nullable: true)
  String id;

  @JsonKey(includeIfNull: false)
  String name;

  @JsonKey(includeIfNull: false)
  String email;

  @JsonKey(includeIfNull: false)
  String password;

  @JsonKey(includeIfNull: false)
  List<Adventure> invites = List<Adventure>();

  @JsonKey(includeIfNull: false)
  List<Adventure> adventures = List<Adventure>();

  @override
  String getId() => id;

  @override
  Player fromJson(Map json) => _$PlayerFromJson(json);

  @override
  String getCollectionName() => Player.collectionName;
}
