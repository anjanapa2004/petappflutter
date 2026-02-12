import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload pet image and return download URL
  Future<String> uploadPetImage({
    required File file,
    required String petId,
  }) async {
    try {
      final ref = _storage.ref().child('pet_images/$petId.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );

      await ref.putFile(file, metadata);

      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Image upload failed: ${e.message}');
    }
  }

  // Delete pet image (useful when deleting pet)
  Future<void> deletePetImage(String petId) async {
    try {
      final ref = _storage.ref().child('pet_images/$petId.jpg');
      await ref.delete();
    } catch (_) {
      // Ignore if file doesn't exist
    }
  }
}

