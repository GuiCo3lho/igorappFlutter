import 'package:igor_app/model/adventure.dart';
import 'package:igor_app/model/player.dart';

abstract class IEntity<T> {
  String getId();
  String getCollectionName();
  Map<dynamic, dynamic> toJson();

  // Solution not scalable at all... :'(
  dynamic fromJson(Map<dynamic, dynamic> json) {
    if (this.runtimeType == Adventure) {
      return Adventure.fromJson(json);
    } else if (this.runtimeType == Player) {
      return Player.fromJson(json);
    }
  }
}
