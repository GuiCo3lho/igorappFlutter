import 'package:igor_app/model/adventure.dart';
import 'package:igor_app/service/base_service.dart';

class AdventureService extends BaseService<Adventure> {
  @override
  Future<List<Adventure>> getAll(String collectionName, fromJson) async =>
      getAll_Override("adventures", (data) => Adventure.fromJson(data));

  @override
  Future<Adventure> getById(String id) => getById_Override(
      id, Adventure.collectionName, (data) => Adventure.fromJson(data));
}
