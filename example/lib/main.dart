import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_utils/entity/firestore_doc.dart';
import 'package:firebase_utils/firebase/firebase_storage_service.dart';
import 'package:firebase_utils/firebase/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initDependencies();
  runApp(const MyApp());
}

initDependencies() {
  Get.lazyPut<FirebaseStorage>(() => FirebaseStorage.instance, fenix: true);
  Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance, fenix: true);
  Get.lazyPut<FireStoreService>(() => FireStoreService.getInstance(Get.find()));
  Get.lazyPut<FirebaseStorageService>(
      () => FirebaseStorageService.getInstance(Get.find()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Firebase Utils'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final FireStoreService _fireStoreService = Get.find();
  // final FirebaseStorageService _firebaseStorageService = Get.find();

  final RxList<UserInfo> userInfo = RxList();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference<UserInfo> get _userCollectionRef =>
      widget._fireStoreService.getCollectionRef(
          'users', (snapshot, _) => UserInfo.fromMap(snapshot.data()!));

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    widget._fireStoreService.getListStream(_userCollectionRef).listen((event) {
      widget.userInfo.value = event;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Name'),
              controller: nameController,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'email'),
              controller: emailController,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(onPressed: _addUser, child: const Text('Add')),
            Expanded(
                child: Obx(
              () => ListView.separated(
                padding: const EdgeInsets.all(12),
                itemBuilder: _userItemBuilder,
                itemCount: widget.userInfo.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _addUser() async {
    if (nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty) {
      await widget._fireStoreService.add(
          UserInfo(
              name: nameController.text,
              email: emailController.text,
              profileImage:
                  'https://fastly.picsum.photos/id/23/200/200.jpg?hmac=IMR2f77CBqpauCb5W6kGzhwbKatX_r9IvgWj6n7FQ7c'),
          _userCollectionRef);
    }

  }

  void _deleteUser(String docId) async {
    await widget._fireStoreService.delete(_userCollectionRef.doc(docId));
  }

  Widget _userItemBuilder(BuildContext context, int index) {
    final user = widget.userInfo[index];
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(user.profileImage),
          radius: 20,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(user.email),
            ],
          ),
        ),
        IconButton(
            onPressed: () => _deleteUser('${user.docId}'),
            icon: const Icon(Icons.delete_outline)),
      ],
    );
  }
}

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
