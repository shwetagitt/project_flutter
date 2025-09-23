import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get collection reference
  CollectionReference collection(String path) {
    return _db.collection(path);
  }

  // Get documents from a collection with optional query
  Future<List<T>> getCollection<T>(
      String path,
      T Function(DocumentSnapshot doc) fromFirestore, {
        Query<Map<String, dynamic>>? query,
      }) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    if (query != null) {
      snapshot = await query.get();
    } else {
      snapshot = await _db.collection(path).get();
    }
    return snapshot.docs.map(fromFirestore).toList();
  }

  // Get single document by ID
  Future<T> getDocument<T>(
      String path,
      String docId,
      T Function(DocumentSnapshot doc) fromFirestore,
      ) async {
    DocumentSnapshot doc = await _db.collection(path).doc(docId).get();
    return fromFirestore(doc);
  }

  // Add a document to a collection
  Future<DocumentReference> addDocument(String path, Map<String, dynamic> data) {
    return _db.collection(path).add(data);
  }

  // Update a document by ID
  Future<void> updateDocument(String path, String docId, Map<String, dynamic> data) {
    return _db.collection(path).doc(docId).update(data);
  }

  // Delete a document by ID
  Future<void> deleteDocument(String path, String docId) {
    return _db.collection(path).doc(docId).delete();
  }

  // Get subcollection documents
  Future<List<T>> getSubCollection<T>(
      String parentPath,
      String parentId,
      String subCollectionPath,
      T Function(DocumentSnapshot doc) fromFirestore,
      {Query<Map<String, dynamic>>? query}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    CollectionReference<Map<String, dynamic>> subCollectionRef =
    _db.collection(parentPath).doc(parentId).collection(subCollectionPath);
    if (query != null) {
      snapshot = await query.get();
    } else {
      snapshot = await subCollectionRef.get();
    }
    return snapshot.docs.map(fromFirestore).toList();
  }

  // Add document to subcollection
  Future<DocumentReference> addDocumentToSubcollection(
      String parentPath,
      String parentId,
      String subCollectionPath,
      Map<String, dynamic> data,
      ) {
    return _db.collection(parentPath).doc(parentId).collection(subCollectionPath).add(data);
  }

  // Update document in subcollection
  Future<void> updateSubcollectionDocument(
      String parentPath,
      String parentId,
      String subCollectionPath,
      String docId,
      Map<String, dynamic> data,
      ) {
    return _db
        .collection(parentPath)
        .doc(parentId)
        .collection(subCollectionPath)
        .doc(docId)
        .update(data);
  }

  // Delete document in subcollection
  Future<void> deleteSubcollectionDocument(
      String parentPath,
      String parentId,
      String subCollectionPath,
      String docId) {
    return _db
        .collection(parentPath)
        .doc(parentId)
        .collection(subCollectionPath)
        .doc(docId)
        .delete();
  }
}
