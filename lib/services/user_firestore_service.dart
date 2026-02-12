import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await users.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> 
      getUserById(String userId) {
    return users.doc(userId).get();
  }
}
