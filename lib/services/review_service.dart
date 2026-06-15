import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siresep_admin/models/review_model.dart';

class ReviewService {
  final CollectionReference<Map<String, dynamic>> _recipeCollection =
      FirebaseFirestore.instance.collection('recipes');

  Future<List<ReviewModel>> fetchReviews() async {
    final recipeSnapshot = await _recipeCollection.get();

    List<ReviewModel> reviews = [];

    for (final recipeDoc in recipeSnapshot.docs) {
      final recipeData = recipeDoc.data();

      final recipeName =
          recipeData['title'] ?? recipeData['name'] ?? 'Resep Tanpa Nama';

      final reviewSnapshot = await recipeDoc.reference
          .collection('reviews')
          .get();

      for (final reviewDoc in reviewSnapshot.docs) {
        reviews.add(
          ReviewModel.fromFirestore(
            reviewDoc: reviewDoc,
            recipeName: recipeName,
          ),
        );
      }
    }

    reviews.sort((a, b) {
      final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
      final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });

    return reviews;
  }

  Future<void> deleteReview({
    required String recipeId,
    required String reviewId,
  }) async {
    await _recipeCollection
        .doc(recipeId)
        .collection('reviews')
        .doc(reviewId)
        .delete();
  }
}
