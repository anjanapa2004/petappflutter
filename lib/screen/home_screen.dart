import 'package:flutter/material.dart';
import 'package:petapp/models/pet_model.dart';
import 'package:petapp/screen/add_pet_screen.dart';
import 'package:petapp/screen/contact_owner_screen.dart';
import 'package:petapp/screen/favorites_screen.dart';
import 'package:petapp/screen/profile_screen.dart';
import 'package:petapp/services/favorite_provider.dart';
import 'package:petapp/services/pet_firestore_service.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petService = PetFirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Adoption"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPetScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<PetModel>>(
        stream: petService.getAllPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No pets available"));
          }

          final pets = snapshot.data!;

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];

              return Card(
  key: ValueKey(pet.id),
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 3,
  child: Column(
    children: [
      // Image
      ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
        child: Image.asset(
  "assets/images/pet1.jpg",
  height: 150,
  width: double.infinity,
  fit: BoxFit.cover,
)
      ),

      // Details
      ListTile(
        title: Text(
          pet.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${pet.breed} • ${pet.age} yrs\n${pet.location}",
        ),
        isThreeLine: true,
        trailing: Consumer<FavoritesProvider>(
          builder: (context, favProvider, _) {
            final isFav = favProvider.isFavorite(pet.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              ),
              onPressed: () => favProvider.toggleFavorite(pet),
            );
          },
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ContactOwnerScreen(ownerId: pet.ownerId),
                ),
              );
            },
            child: const Text("Contact Owner"),
          ),
        ),
      ),
    ],
  ),
);
   },
          );
        },
      ),
    );
  }
}
