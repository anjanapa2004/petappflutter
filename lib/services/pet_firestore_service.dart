import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petapp/models/pet_model.dart';

class PetFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _petsRef =>
      _firestore.collection('pets');
// GET ALL PETS (Newest First)

  Stream<List<PetModel>> getAllPets() {
    return _petsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PetModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

// ADD NEW PET

  Future<String> addPet(PetModel pet) async {
    final docRef = _petsRef.doc();

    await docRef.set({
      ...pet.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }


}
