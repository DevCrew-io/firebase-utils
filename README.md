# Firebase Utils
[![pub package](https://img.shields.io/pub/v/firebase_utils.svg)](https://pub.dev/packages/firebase_utils)
[![license](https://img.shields.io/badge/license-MIT-green)](https://github.com/DevCrew-io/firebase-utils/blob/main/LICENSE)
![](https://img.shields.io/badge/Code-Dart-informational?style=flat&logo=dart&color=29B1EE)
![](https://img.shields.io/badge/Code-Flutter-informational?style=flat&logo=flutter&color=0C459C)

This package offers a range of utilities for Firestore and Fire Storage, including CRUD operations and other essential functions. You can easily perform common database operations and efficiently store and manage data, allowing you to focus on developing the core functionality of your app.
## Installation
To use Firebase Utils in your project, add the following dependency to your ```pubspec.yaml``` file
```dart
dependencies:
  firebase_utils: ^<latest-version>
```
Then run ```flutter pub get``` to install the package.

## Example
![ezgif com-resize](https://user-images.githubusercontent.com/93918747/231386688-e1d0dabd-28a0-4586-930b-c028b4c86147.gif)

## Usage
### Firestore Utilities
Import the package in your Dart code
```dart
import 'package:firebase_utils/entity/firestore_doc.dart';
import 'package:firebase_utils/firebase/firestore_service.dart';
```
Create an Entity UserInfo which can extends FireStoreDoc or TimeStampedFireStoreDoc. If
you need createdDate and updatedDate fields in firestore table then extends with TimeStampedFireStoreDoc.
```dart
class UserInfo extends FireStoreDoc {
  final String name;
  final String email;
  final String profileImage;

  UserInfo(
      {required this.name, required this.email, required this.profileImage});

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'email': email,
        'profileImage': profileImage,
      };

  factory UserInfo.fromMap(Map<String, dynamic> map) => UserInfo(
        name: map['name'] as String,
        email: map['email'] as String,
        profileImage: map['profileImage'] as String,
      );
}
```
Create a collection reference of ```users.``` users is a collection type of UserInfo in firestore db
```dart
CollectionReference<UserInfo> get _userCollectionRef =>
      widget._fireStoreService.getCollectionRef(
          'users', (snapshot, _) => UserInfo.fromMap(snapshot.data()!));
```
Get a instance of ```FireStoreService``` to perform all Firestore operations. 
```dart
final FireStoreService firestoreService =  FireStoreService.getInstance(FirebaseFirestore.instance)
```

Fetch all documents of collection in Streams
```dart
firestoreService.getListStream(_userCollectionRef).listen((event) {
    List<UserInfo> = event
})
```
Insert data
```dart
firestoreService.add(UserInfo(name: 'abc',email: 'abc@gmail.com',profileImage:'imageUrl'),_userCollectionRef)
```

Delete Object
```dart
await fireStoreService.delete(_userCollectionRef.doc(docId));
```
You can use all other functions for Firestore operations defined in FireStoreService.
### FirebaseStorage Utilities
Import the package in your Dart code
```dart
import 'package:firebase_utils/firebase/firebase_storage_service.dart';
```
Get a instance of ```FirebaseStorageService``` to perform all FirebaseStorage operations.
```dart
final FirebaseStorageService firebaseStorageService =  FirebaseStorageService.getInstance( FirebaseStorage.instance)
```
Upload a file
```dart
firebaseStorageService.updateFileAndGetUrl(downloadUrl, file)
```
## Author
[DevCrew.IO](https://devcrew.io/)

<h3 align="left">Connect with Us:</h3>
<p align="left">
<a href="https://devcrew.io" target="blank"><img align="center" src="https://devcrew.io/wp-content/uploads/2022/09/logo.svg" alt="devcrew.io" height="35" width="35" /></a>
<a href="https://www.linkedin.com/company/devcrew-io/mycompany/" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="mycompany" height="30" width="40" /></a>
<a href="https://github.com/DevCrew-io" target="blank"><img align="center" src="https://cdn-icons-png.flaticon.com/512/733/733553.png" alt="DevCrew-io" height="32" width="32" /></a>
</p>


## Contributing
Contributions, issues, and feature requests are welcome!
## Show your Support
Give a star if this project helped you.

## Bugs and feature requests
Have a bug or a feature request? Please first search for existing and closed issues.
If your problem or idea is not addressed yet, [please open a new issue](https://github.com/DevCrew-io/firebase-utils/issues/new).

## Copyright & License
Code copyright 2023–2024 [DevCrew I/O](https://devcrew.io/).
Code released under the [MIT license](https://github.com/DevCrew-io/firebase-utils/blob/main/LICENSE).


