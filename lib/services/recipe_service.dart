import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siresep_admin/models/recipe_model.dart';

class RecipeService {
  final CollectionReference<Map<String, dynamic>> _recipeCollection =
      FirebaseFirestore.instance.collection('recipes');

  Stream<QuerySnapshot<Map<String, dynamic>>> getRecipes() {
    return _recipeCollection.orderBy('createdAt', descending: true).snapshots();
  }

  Stream<List<RecipeModel>> watchRecipes() {
    return _recipeCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RecipeModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<List<RecipeModel>> fetchRecipes() async {
    final snapshot = await _recipeCollection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => RecipeModel.fromFirestore(doc)).toList();
  }

  Future<void> addRecipe(Map<String, dynamic> data) async {
    await _recipeCollection.add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createRecipe(RecipeModel recipe) async {
    await _recipeCollection.add(recipe.toCreateMap());
  }

  Future<void> updateRecipe(String id, Map<String, dynamic> data) async {
    await _recipeCollection.doc(id).update(data);
  }

  Future<void> updateRecipeModel(RecipeModel recipe) async {
    if (recipe.id.isEmpty) {
      throw Exception('ID resep tidak ditemukan.');
    }

    await _recipeCollection.doc(recipe.id).update(recipe.toUpdateMap());
  }

  Future<void> deleteRecipe(String id) async {
    await _recipeCollection.doc(id).delete();
  }
}
