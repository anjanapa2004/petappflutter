import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petapp/models/pet_model.dart';
import 'package:petapp/services/pet_firestore_service.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final breedController = TextEditingController();
  final locationController = TextEditingController();

  bool _isLoading = false;

  /// SAVE PET TO FIRESTORE (NO STORAGE)
  Future<void> savePet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final pet = PetModel(
        id: '',
        name: nameController.text.trim(),
        breed: breedController.text.trim(),
        age: int.parse(ageController.text.trim()),
        location: locationController.text.trim(),
        imageUrl: '', // 🔥 No storage
        ownerId: user.uid,
        createdAt: DateTime.now(),
      );

      await PetFirestoreService().addPet(pet);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pet added successfully 🐾")),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint("ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    breedController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Pet")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              
              _inputField(controller: nameController, label: "Pet Name"),
              _inputField(controller: breedController, label: "Breed"),
              _inputField(
                controller: ageController,
                label: "Age",
                keyboardType: TextInputType.number,
                isAge: true,
              ),
              _inputField(
                controller: locationController,
                label: "Location",
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : savePet,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Pet"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool isAge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter $label";
          }
          if (isAge && int.tryParse(value) == null) {
            return "Enter valid age";
          }
          return null;
        },
      ),
    );
  }
}
