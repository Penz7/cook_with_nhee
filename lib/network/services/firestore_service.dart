import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../firebase_options.dart';

class FirestoreService extends GetxService {
  FirebaseFirestore? firestore;

  static final FirestoreService _instance = FirestoreService._internal();

  FirestoreService._internal();

  factory FirestoreService() => _instance;

  Future<FirestoreService> init() async {
    // final isConnected = await NetworkHelper.instance.checkConnection();
    //
    // if (!isConnected) {
    //   print("No internet connection");
    //   return this;
    // }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firestore = FirebaseFirestore.instance;
    return this;
  }


  Future<void> write<T>(
      String collection,
      String document,
      T model,
      Map<String, dynamic> Function(T) toMap,
      ) async {
    if (firestore == null) throw Exception("Firestore chưa được khởi tạo");

    final docRef = firestore!.collection(collection).doc(document);
    await docRef.set(toMap(model));
  }

  Future<T> read<T>(
      String collection,
      String document,
      T Function(DocumentSnapshot) fromDocument,
      ) async {
    if (firestore == null) throw Exception("Firestore chưa được khởi tạo");

    final docRef = firestore!.collection(collection).doc(document);
    final doc = await docRef.get();
    if (!doc.exists) throw Exception("Document không tồn tại");
    return fromDocument(doc);
  }

  Future<List<T>> readList<T>(
      String collection,
      T Function(DocumentSnapshot) fromDocument,
      ) async {
    if (firestore == null) throw Exception("Firestore chưa được khởi tạo");

    final snapshot = await firestore!.collection(collection).get();
    return snapshot.docs.map((doc) => fromDocument(doc)).toList();
  }


}
