import 'package:flutter/material.dart';
import 'package:siresep_admin/core/widgets/admin_page_wrapper.dart';

class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminPageWrapper(
      title: 'Template Meal Plan',
      subtitle: 'Kelola template meal plan mingguan',
    );
  }
}
