import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
part 'firebase_storage_service_impl.dart';

/// This class is for FirebaseStorage Manager
/// Upload File
/// Update File
/// Delete File
abstract class FirebaseStorageService {
  /// This function is for Uploading a new file and
  /// get uploaded file url
  Future<String?> uploadFileAndGetUrl(Uint8List file, String ref);

  /// This function is for updating an existing file and
  /// get updated file url
  Future<String?> updateFileAndGetUrl(String downloadUrl, Uint8List file);

  /// Delete a file by providing file reference
  Future deleteFile(String ref);

  /// Delete a file by providing file url
  Future deleteFileByUrl(String url);

  static FirebaseStorageService? _instance;

  static FirebaseStorageService getInstance(FirebaseStorage firebaseStorage) =>
      _instance ??= _FirebaseStorageServiceImpl(firebaseStorage);
}
