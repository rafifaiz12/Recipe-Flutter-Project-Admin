import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:siresep_admin/models/meal_plan_model.dart';
import 'package:siresep_admin/services/meal_plan_service.dart';

class MealPlanTemplateProvider extends ChangeNotifier {
  final MealPlanTemplateService _service;

  MealPlanTemplateProvider({MealPlanTemplateService? service})
    : _service = service ?? MealPlanTemplateService();

  StreamSubscription<List<MealPlanTemplateModel>>? _subscription;

  List<MealPlanTemplateModel> _templates = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MealPlanTemplateModel> get templates => List.unmodifiable(_templates);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenTemplates() {
    _setLoading(true);

    _subscription?.cancel();
    _subscription = _service.watchTemplates().listen(
      (templates) {
        _templates = templates;
        _errorMessage = null;
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = error.toString();
        _setLoading(false);
      },
    );
  }

  Future<void> createTemplate(MealPlanTemplateModel template) async {
    await _service.createTemplate(template);
  }

  Future<void> updateTemplate(MealPlanTemplateModel template) async {
    await _service.updateTemplate(template);
  }

  Future<void> deleteTemplate(String id) async {
    await _service.deleteTemplate(id);
  }

  List<MealPlanTemplateModel> filterByStatus(String selectedStatus) {
    if (selectedStatus == 'All Status') return templates;

    return templates.where((template) {
      return template.status == selectedStatus.toLowerCase();
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
