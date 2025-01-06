import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseRepository<T> {
  final CollectionReference collection;

  BaseRepository(this.collection);

  Future<void> create(T item) async {
    await collection.add(itemToMap(item));
  }

  Future<T?> get(String id) async {
    final doc = await collection.doc(id).get();
    if (doc.exists) {
      return mapToItem(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> update(String id, T item) async {
    await collection.doc(id).update(itemToMap(item));
  }

  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  Future<List<T>> getAll() async {
    final querySnapshot = await collection.get();
    return querySnapshot.docs
        .map((doc) => mapToItem(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> itemToMap(T item);

  T mapToItem(Map<String, dynamic> map);
}