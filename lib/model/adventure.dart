import 'package:igor_app/model/entity.dart';
import 'package:igor_app/model/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'adventure.g.dart';

@JsonSerializable(
    explicitToJson: true, createToJson: true, createFactory: true, anyMap: true)
class Adventure implements IEntity<Adventure> {
  
  static String collectionName = "adventures";
  factory Adventure.fromJson(Map<dynamic, dynamic> json) =>
      _$AdventureFromJson(json);
  Map<dynamic, dynamic> toJson() => _$AdventureToJson(this);

  Adventure({this.id, this.title, this.textBody});

  @JsonKey(includeIfNull: false, nullable: true)
  String id;

  @JsonKey(includeIfNull: false)
  String title;

  @JsonKey(includeIfNull: false)
  String textBody;

  @JsonKey(includeIfNull: false)
  Player ownerPlayer;

  @JsonKey(includeIfNull: false)
  List<Player> players = List<Player>();

  @override
  String getId() => id;

  @override
  Adventure fromJson(Map json) => _$AdventureFromJson(json);

  @override
  String getCollectionName() => Adventure.collectionName;
}
