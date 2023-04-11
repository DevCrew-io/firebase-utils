import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/firestore_doc.dart';
import 'firestore_fields.dart';

part 'firestore_service_impl.dart';

/// This class is for FirebaseFirestore Manager to
/// perform all Firestore operations
abstract class FireStoreService {
  /// [obj] is a user custom object which extends [FireStoreDoc],

  /// This method is used to add a new document to a collection.
  Future<T> add<T extends FireStoreDoc>(
    T obj,

    /// This is the reference of the collection
    CollectionReference collectionReference,
  );

  /// This function is used to completely replace the data
  /// in a document with the provided object.

  /// If the document does not exist, this method will create
  /// a new document with the provided object.

  /// If the document already exists, it will overwrite the
  /// existing data with the new object.
  Future addUpdateDocument(
    FireStoreDoc obj,

    /// This is the reference of a document
    DocumentReference documentReference,
  );

  /// This method is used to update specific fields in a
  /// document with the provided object.

  /// This method only updates the fields that are specified in the object,
  /// leaving the other fields unchanged

  /// If the document does not exist, this method will throw an error.
  Future update(FireStoreDoc obj, DocumentReference docRef);

  /// Method is used to update specific fields in a document with
  /// a JavaScript object
  /// The object obj contains key-value pairs where the keys represent
  /// the field names to update and the values represent the new values
  /// to set for those fields
  Future updateField(Map<String, Object?> obj, DocumentReference docRef);

  /// This method is used to delete a document
  /// When you call this method, Firestore deletes the
  /// entire document and all of its contents from the database.
  Future delete(DocumentReference docRef);

  /// This function is used to get document from a Firestore collection
  /// using its reference
  Future<T?> get<T extends FireStoreDoc>(DocumentReference<T> docRef);

  /// This method is used to fetch stream of data from firestore db
  /// for Query based result
  Stream<List<T>> getListStreamByQuery<T extends FireStoreDoc>(Query<T> query);

  /// This method is used to fetch stream of data from collection
  /// [colRef] that represents the Firestore collection from
  /// which the data is retrieved.
  Stream<List<T>> getListStream<T extends FireStoreDoc>(
      CollectionReference<T> colRef);

  /// A method that retrieves all documents from a Firestore
  /// collection specified by a [colRef]
  Future<List<T>> getList<T extends FireStoreDoc>(
    CollectionReference<T> colRef,
  );

  /// A method that retrieves all documents from a Firestore
  /// collection that match a specified query.
  Future<List<T>> getListByQuery<T extends FireStoreDoc>(Query<T> query);

  ///  A method that returns a CollectionReference object for a
  ///  Firestore collection located at a specified path, with a
  ///  specified fromFirestore function to convert Firestore documents
  ///  to objects of type T.
  CollectionReference<T> getCollectionRef<T extends FireStoreDoc>(
    String path,
    FromFirestore<T> fromFirestore,
  );

  /// A method that returns a DocumentReference object for a
  /// Firestore document located at a specified path, with a
  /// specified fromFirestore function to convert Firestore documents
  /// to objects of type T.
  DocumentReference<T> getDocumentRef<T extends FireStoreDoc>(
    String path,
    FromFirestore<T> fromFirestore,
  );

  /// a method that returns a CollectionReference object for a sub collection
  /// of a Firestore document located at a specified path, with a specified
  /// fromFirestore function to convert Firestore documents
  /// to objects of type T.
  CollectionReference<T> getSubCollectionRef<T extends FireStoreDoc>(
    String collectionPath,
    String docPath,
    String subCollection,
    FromFirestore<T> fromFirestore,
  );

  /// A method that returns a DocumentReference
  DocumentReference getCountDocumentRef<T extends FireStoreDoc>(
      String collectionPath, String docPath);

  static FireStoreService? _instance;

  static FireStoreService getInstance(FirebaseFirestore fireStore) =>
      _instance ??= _FireStoreServiceImpl(fireStore);
}
