import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igor_app/model/entity.dart';

abstract class BaseService<T extends IEntity<T>> {
  Future<List<T>> getAll(
      String collectionName, dynamic Function(Map<dynamic, dynamic>) fromJson);
  Future<T> getById(String id);

  Future save(T entity) async {
    Firestore.instance
        .collection(entity.getCollectionName())
        .add(entity.toJson())
        .then((dbDoc) => dbDoc.updateData({"id": dbDoc.documentID}));
  }

  Future update(T entity) async {
    Firestore.instance
        .collection(entity.getCollectionName())
        .document(entity.getId())
        .updateData(entity.toJson());
  }

  Future<T> getById_Override(String id, String collectionName,
      dynamic Function(Map<dynamic, dynamic>) fromJson) async {
    T dbEntity;
    await Firestore.instance
        .collection(collectionName)
        .document(id)
        .get()
        .then((snap) => dbEntity = fromJson(snap.data));

    return Future.value(dbEntity);
  }

  Future<List<T>> getAll_Override(String collectionName,
      dynamic Function(Map<dynamic, dynamic>) fromJson) async {
    List<T> entities = List();

    await Firestore.instance
        .collection(collectionName)
        .getDocuments()
        .then((snaps) {
      snaps.documents.forEach((doc) => entities.add(fromJson(doc.data)));
    });

    return Future.value(entities);
  }
}
