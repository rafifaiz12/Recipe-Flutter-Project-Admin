import 'package:flutter/material.dart';
import 'package:siresep_admin/models/review_model.dart';
import 'package:siresep_admin/services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewService _reviewService = ReviewService();

  List<ReviewModel> _reviews = [];

  bool _isLoading = false;

  String? _errorMessage;

  List<ReviewModel> get reviews => _reviews;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchReviews() async {
    try {
      _isLoading = true;
      _errorMessage = null;

      notifyListeners();

      _reviews = await _reviewService.fetchReviews();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteReview({
    required String recipeId,
    required String reviewId,
  }) async {
    try {
      await _reviewService.deleteReview(recipeId: recipeId, reviewId: reviewId);

      _reviews.removeWhere((review) => review.id == reviewId);

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();

      rethrow;
    }
  }
}
