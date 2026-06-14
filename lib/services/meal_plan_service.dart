import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siresep_admin/models/meal_plan_model.dart';

class MealPlanTemplateService {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('meal_plan_templates');

  Stream<List<MealPlanTemplateModel>> watchTemplates() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MealPlanTemplateModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> createTemplate(MealPlanTemplateModel template) async {
    await _collection.add(template.toCreateMap());
  }

  Future<void> updateTemplate(MealPlanTemplateModel template) async {
    if (template.id.isEmpty) {
      throw Exception('ID template meal plan tidak ditemukan.');
    }

    await _collection.doc(template.id).update(template.toUpdateMap());
  }

  Future<void> deleteTemplate(String id) async {
    await _collection.doc(id).delete();
  }
}
