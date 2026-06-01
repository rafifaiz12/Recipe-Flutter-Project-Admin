import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeService {
  final CollectionReference<Map<String, dynamic>> recipes = FirebaseFirestore
      .instance
      .collection('recipes');

  Future<void> addRecipe(Map<String, dynamic> data) async {
    await recipes.add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateRecipe(String id, Map<String, dynamic> data) async {
    await recipes.doc(id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRecipes() {
    return recipes.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> deleteRecipe(String id) async {
    await recipes.doc(id).delete();
  }
}
