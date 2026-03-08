import 'package:flutter/material.dart';
import 'package:petapp/services/favorite_provider.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final favorites = favProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Pets"),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                favProvider.clearFavorites();
              },
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No favorite pets yet!",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (context, index) {
                final pet = favorites[index];

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:Icon(Icons.pets),
                   
                  ),
                  title: Text(
                    pet.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("${pet.breed} • ${pet.age} yrs"),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      favProvider.removeFavorite(pet.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
