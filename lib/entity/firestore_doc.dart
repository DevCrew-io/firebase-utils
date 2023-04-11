import 'package:cloud_firestore/cloud_firestore.dart';

/// This is a common properties of any Document
abstract class FireStoreDoc {
  /// This property is for override the ID of a Document
  String? docId;

  /// This function is override for conversion of
  /// user object to Json format
  Map<String, dynamic> toMap();
}

abstract class TimeStampedFireStoreDoc extends FireStoreDoc {
  /// Every document has its own created DateTime
  abstract final Timestamp createdDate;

  /// Every document has its  updated DateTime
  Timestamp? updatedDate;
}
