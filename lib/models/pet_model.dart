import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {
  final String id;
  final String name;
  final int age;
  final String breed;
  final String location;
  // final String imageUrl;
  final String ownerId;
  final DateTime createdAt;

  PetModel({
    required this.id,
    required this.name,
    required this.age,
    required this.breed,
    required this.location,
    // required this.imageUrl,
    required this.ownerId,
    required this.createdAt,
  });

  /// Convert Firestore → PetModel
  factory PetModel.fromMap(Map<String, dynamic> data, String documentId) {
    Timestamp? timestamp = data['createdAt'];

    return PetModel(
      id: documentId,
      name: data['name'] ?? '',
      age: (data['age'] ?? 0).toInt(),
      breed: data['breed'] ?? '',
      location: data['location'] ?? '',
      // imageUrl: data['imageUrl'] ?? '',
      ownerId: data['ownerId'] ?? '',
      createdAt:
          timestamp != null ? timestamp.toDate() : DateTime.now(),
    );
  }

  /// Convert PetModel → Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'breed': breed,
      'location': location,
      // 'imageUrl': imageUrl,
      'ownerId': ownerId,
      'createdAt': createdAt,
    };
  }
}
