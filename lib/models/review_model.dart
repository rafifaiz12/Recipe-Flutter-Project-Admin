import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String recipeId;
  final String recipeName;

  final String userId;
  final String userName;
  final String userPhotoUrl;

  final int rating;
  final String comment;

  final Timestamp? createdAt;

  ReviewModel({
    required this.id,
    required this.recipeId,
    required this.recipeName,
    required this.userId,
    required this.userName,
    required this.userPhotoUrl,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromFirestore({
    required QueryDocumentSnapshot<Map<String, dynamic>> reviewDoc,
    required String recipeName,
  }) {
    final data = reviewDoc.data();

    return ReviewModel(
      id: data['id'] ?? reviewDoc.id,
      recipeId: data['recipeId'] ?? '',
      recipeName: recipeName,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown User',
      userPhotoUrl: data['userPhotoUrl'] ?? '',
      rating: (data['rating'] ?? 0).toInt(),
      comment: data['comment'] ?? '',
      createdAt: data['createdAt'],
    );
  }
}
