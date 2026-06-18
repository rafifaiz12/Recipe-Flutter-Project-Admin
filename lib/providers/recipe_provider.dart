import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:siresep_admin/models/recipe_model.dart';
import 'package:siresep_admin/services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _recipeService;

  RecipeProvider({RecipeService? recipeService})
    : _recipeService = recipeService ?? RecipeService();

  StreamSubscription<List<RecipeModel>>? _subscription;

  List<RecipeModel> _recipes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RecipeModel> get recipes => List.unmodifiable(_recipes);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenRecipes() {
    _setLoading(true);

    _subscription?.cancel();
    _subscription = _recipeService.watchRecipes().listen(
      (recipes) {
        _recipes = recipes;
        _errorMessage = null;
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = error.toString();
        _setLoading(false);
      },
    );
  }

  Future<void> fetchRecipes() async {
    _setLoading(true);

    try {
      _recipes = await _recipeService.fetchRecipes();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createRecipe(RecipeModel recipe) async {
    try {
      await _recipeService.createRecipe(recipe);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateRecipe(RecipeModel recipe) async {
    try {
      await _recipeService.updateRecipeModel(recipe);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _recipeService.deleteRecipe(id);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  List<RecipeModel> filterRecipes({
    required String searchQuery,
    required String selectedStatus,
    required String selectedCategory,
  }) {
    final query = searchQuery.toLowerCase();

    return _recipes.where((recipe) {
      final title = recipe.title.toLowerCase();

      final matchesSearch = query.isEmpty || title.contains(query);

      final matchesStatus =
          selectedStatus == 'Semua Status' || recipe.status == selectedStatus;

      final matchesCategory =
          selectedCategory == 'Semua Kategori' ||
          recipe.dishType == selectedCategory ||
          recipe.cuisine == selectedCategory ||
          recipe.mealType == selectedCategory ||
          recipe.dietType == selectedCategory;

      return matchesSearch && matchesStatus && matchesCategory;
    }).toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
