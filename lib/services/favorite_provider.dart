import 'package:flutter/material.dart';
import 'package:petapp/models/pet_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<PetModel> _favorites = [];

  List<PetModel> get favorites => _favorites;

  bool isFavorite(String petId) {
    return _favorites.any((pet) => pet.id == petId);
  }

  void toggleFavorite(PetModel pet) {
    if (isFavorite(pet.id)) {
      _favorites.removeWhere((p) => p.id == pet.id);
    } else {
      _favorites.add(pet);
    }
    notifyListeners();
  }

  void removeFavorite(String petId) {
    _favorites.removeWhere((pet) => pet.id == petId);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
