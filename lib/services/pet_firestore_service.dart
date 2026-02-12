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
// UPDATE PET
  
  Future<void> updatePet(PetModel pet) async {
    await _petsRef.doc(pet.id).update({
      'name': pet.name,
      'age': pet.age,
      'breed': pet.breed,
      'location': pet.location,
      'imageUrl': pet.imageUrl,
    });
  }

  // DELETE PET

  Future<void> deletePet(String petId) async {
    await _petsRef.doc(petId).delete();
  }

  // GET PETS BY OWNER

  Stream<List<PetModel>> getPetsByOwner(String ownerId) {
    return _petsRef
        .where('ownerId', isEqualTo: ownerId)
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
}
