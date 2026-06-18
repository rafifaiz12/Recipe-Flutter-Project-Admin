import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeIngredient {
  final String name;
  final String quantity;
  final String unit;

  const RecipeIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(
      name: map['name']?.toString() ?? '',
      quantity: map['quantity']?.toString() ?? '',
      unit: map['unit']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'quantity': quantity, 'unit': unit};
  }
}

class RecipeModel {
  final String id;
  final String title;
  final String description;
  final List<String> categories;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final String status;
  final int cookTimeMinutes;
  final String difficulty;
  final double ratingAverage;
  final int reviewCount;
  final String imageUrl;
  final bool trending;
  final dynamic createdAt;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categories,
    required this.ingredients,
    required this.steps,
    required this.status,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.ratingAverage,
    required this.reviewCount,
    required this.imageUrl,
    this.trending = false,
    this.createdAt,
  });

  factory RecipeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return RecipeModel.fromMap(data, id: doc.id);
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map, {String id = ''}) {
    final rawIngredients = map['ingredients'];
    final parsedIngredients = <RecipeIngredient>[];

    if (rawIngredients is List) {
      for (final item in rawIngredients) {
        if (item is Map) {
          parsedIngredients.add(
            RecipeIngredient.fromMap(Map<String, dynamic>.from(item)),
          );
        } else {
          parsedIngredients.add(
            RecipeIngredient(name: item.toString(), quantity: '', unit: ''),
          );
        }
      }
    }

    return RecipeModel(
      id: id.isNotEmpty ? id : map['id']?.toString() ?? '',

      title: map['title']?.toString() ?? '',

      description: map['description']?.toString() ?? '',

      categories: _toStringList(map['categories']),

      ingredients: parsedIngredients,

      steps: _toStringList(map['steps']),

      status: map['status']?.toString() ?? 'Draft',

      cookTimeMinutes: (map['cookTimeMinutes'] as num?)?.toInt() ?? 0,

      difficulty: map['difficulty']?.toString() ?? 'Easy',

      ratingAverage: (map['ratingAverage'] as num?)?.toDouble() ?? 0.0,

      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,

      imageUrl: map['imageUrl']?.toString() ?? '',

      trending: map['trending'] ?? false,

      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'categories': categories,
      'ingredients': ingredients.map((item) => item.toMap()).toList(),
      'steps': steps,
      'status': status,
      'cookTimeMinutes': cookTimeMinutes,
      'difficulty': difficulty,
      'ratingAverage': ratingAverage,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'trending': trending,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toCreateMap() {
    final data = toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    return data;
  }

  Map<String, dynamic> toUpdateMap() {
    final data = toMap();
    data.remove('createdAt');
    return data;
  }

  RecipeModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? categories,
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
    String? status,
    int? cookTimeMinutes,
    String? difficulty,
    double? ratingAverage,
    int? reviewCount,
    String? imageUrl,
    bool? trending,
    dynamic createdAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      status: status ?? this.status,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      difficulty: difficulty ?? this.difficulty,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      trending: trending ?? this.trending,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return [];
  }
}
