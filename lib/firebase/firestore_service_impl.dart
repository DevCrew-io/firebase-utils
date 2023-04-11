part of 'firestore_service.dart';

class _FireStoreServiceImpl extends FireStoreService {
  final FirebaseFirestore _fireStore;

  _FireStoreServiceImpl(this._fireStore);

  @override
  Future<T> add<T extends FireStoreDoc>(
      T obj, CollectionReference collectionReference) async {
    final result = await collectionReference.add(obj);
    obj.docId = result.id;
    return obj;
  }

  @override
  Future addUpdateDocument(
          FireStoreDoc obj, DocumentReference documentReference) =>
      documentReference.set(obj);

  @override
  Future update(FireStoreDoc obj, DocumentReference docRef) =>
      docRef.update(obj.toMap());

  @override
  Future updateField(Map<String, Object?> obj, DocumentReference docRef) =>
      docRef.update(obj);

  @override
  Future delete(DocumentReference docRef) => docRef.delete();

  @override
  Future<T?> get<T extends FireStoreDoc>(DocumentReference<T> docRef) async {
    final documentSnapshot = await docRef.get();
    if (documentSnapshot.exists) {
      return documentSnapshot.toPojo();
    } else {
      return null;
    }
  }

  @override
  Stream<List<T>> getListStream<T extends FireStoreDoc>(
      CollectionReference<T> colRef) {
    return colRef
        .snapshots()
        .map((event) => event.docs.map((e) => e.toPojo()).toList());
  }

  @override
  Stream<List<T>> getListStreamByQuery<T extends FireStoreDoc>(Query<T> query) {
    return query
        .snapshots()
        .asyncMap((event) => event.docs.map((e) => e.toPojo()).toList());
  }

  @override
  Future<List<T>> getList<T extends FireStoreDoc>(
    CollectionReference<T> colRef,
  ) async {
    final data = await colRef.get().then((value) => value.docs);
    return data.map((e) => e.toPojo()).toList();
  }

  @override
  Future<List<T>> getListByQuery<T extends FireStoreDoc>(Query<T> query) async {
    final data = await query.get().then((value) => value.docs);
    return data.map((e) => e.toPojo()).toList();
  }

  @override
  CollectionReference<T> getCollectionRef<T extends FireStoreDoc>(
    String path,
    FromFirestore<T> fromFirestore,
  ) =>
      _fireStore.collection(path).withConverter<T>(
            fromFirestore: fromFirestore,
            toFirestore: (item, _) => item.toMap(),
          );

  @override
  DocumentReference<T> getDocumentRef<T extends FireStoreDoc>(
          String path, FromFirestore<T> fromFirestore) =>
      _fireStore.doc(path).withConverter<T>(
            fromFirestore: fromFirestore,
            toFirestore: (item, _) => item.toMap(),
          );

  @override
  CollectionReference<T> getSubCollectionRef<T extends FireStoreDoc>(
    String collectionPath,
    String docPath,
    String subCollection,
    FromFirestore<T> fromFirestore,
  ) =>
      _fireStore
          .collection(collectionPath)
          .doc(docPath)
          .collection(subCollection)
          .withConverter<T>(
            fromFirestore: fromFirestore,
            toFirestore: (item, _) => item.toMap(),
          );

  @override
  DocumentReference getCountDocumentRef<T extends FireStoreDoc>(
          String collectionPath, String docPath) =>
      _fireStore.collection(collectionPath).doc(docPath);
}

/// Extension function of DocumentSnapshot
/// The purpose of this extension method is to simplify the conversion
/// of a DocumentSnapshot to an instance of a class that extends the
/// FireStoreDoc class
extension _DocumentParser<T extends FireStoreDoc> on DocumentSnapshot<T> {
  T? toPojo() {
    final document = data();
    if (T is TimeStampedFireStoreDoc) {
      (document as TimeStampedFireStoreDoc).updatedDate =
          get(FireStoreFields.updatedAt);
    }
    document?.docId = id;
    return document;
  }
}

/// Extension function of QueryDocumentSnapshot
extension _QueryDocumentParser<T extends FireStoreDoc>
    on QueryDocumentSnapshot<T> {
  T toPojo() {
    final document = data();
    if (T is TimeStampedFireStoreDoc) {
      (document as TimeStampedFireStoreDoc).updatedDate =
          get(FireStoreFields.updatedAt);
    }
    document.docId = id;
    return document;
  }
}
