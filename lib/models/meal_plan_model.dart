import 'package:cloud_firestore/cloud_firestore.dart';

class MealPlanTemplateModel {
  final String id;
  final String name;
  final String description;
  final String status;
  final Map<String, Map<String, String?>> mealPlan;
  final dynamic createdAt;
  final dynamic updatedAt;

  const MealPlanTemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.mealPlan,
    this.createdAt,
    this.updatedAt,
  });

  factory MealPlanTemplateModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return MealPlanTemplateModel.fromMap(data, id: doc.id);
  }

  factory MealPlanTemplateModel.fromMap(
    Map<String, dynamic> map, {
    String id = '',
  }) {
    return MealPlanTemplateModel(
      id: id,
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      status: map['status']?.toString() ?? 'draft',
      mealPlan: _parseMealPlan(map['mealPlan']),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'mealPlan': mealPlan,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'mealPlan': mealPlan,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static Map<String, Map<String, String?>> _parseMealPlan(dynamic value) {
    final result = <String, Map<String, String?>>{};

    if (value is! Map) return result;

    for (final dayEntry in value.entries) {
      final day = dayEntry.key.toString();
      final meals = <String, String?>{};

      if (dayEntry.value is Map) {
        final rawMeals = dayEntry.value as Map;
        for (final mealEntry in rawMeals.entries) {
          meals[mealEntry.key.toString()] = mealEntry.value?.toString();
        }
      }

      result[day] = meals;
    }

    return result;
  }
}
