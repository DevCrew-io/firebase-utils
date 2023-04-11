part of 'firebase_storage_service.dart';

class _FirebaseStorageServiceImpl extends FirebaseStorageService {
  final FirebaseStorage _firebaseStorage;

  _FirebaseStorageServiceImpl(this._firebaseStorage);

  @override
  Future<String?> uploadFileAndGetUrl(Uint8List file, String ref) async {
    try {
      await _firebaseStorage.ref(ref).putData(file);
      return await _firebaseStorage.ref(ref).getDownloadURL();
    } on FirebaseException catch (e) {
      return null;
    }
  }

  @override
  Future<String?> updateFileAndGetUrl(
      String downloadUrl, Uint8List file) async {
    try {
      Reference referenceImageToUpload =
          _firebaseStorage.refFromURL(downloadUrl);
      await referenceImageToUpload.putData(file);
      return await referenceImageToUpload.getDownloadURL();
    } on FirebaseException catch (e) {
      return null;
    }
  }

  @override
  Future deleteFile(String ref) async {
    try {
      await _firebaseStorage.ref(ref).delete();
    } on FirebaseException catch (e) {
      return null;
    }
  }

  @override
  Future deleteFileByUrl(String url) async {
    try {
      await _firebaseStorage.refFromURL(url).delete();
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
