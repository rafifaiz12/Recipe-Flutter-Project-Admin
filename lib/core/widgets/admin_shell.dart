import 'package:flutter/material.dart';
import 'package:siresep_admin/app/admin_routes.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/widgets/admin_sidebar.dart';
import 'package:siresep_admin/pages/analytics/analytics_page.dart';
import 'package:siresep_admin/pages/meal_plan/meal_plan_page.dart';
import 'package:siresep_admin/pages/recipes/recipes_page.dart';
import 'package:siresep_admin/pages/reviews/reviews_page.dart';
import 'package:siresep_admin/pages/users/users_page.dart';

class AdminShell extends StatelessWidget {
  final String currentRoute;

  const AdminShell({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AdminSidebar(currentRoute: currentRoute),
          Expanded(child: _buildPage()),
        ],
      ),
    );
  }

  Widget _buildPage() {
    switch (currentRoute) {
      case AdminRoutes.analytics:
        return const AnalyticsPage();
      case AdminRoutes.recipes:
        return const RecipesPage();
      case AdminRoutes.mealPlan:
        return const MealPlanPage();
      case AdminRoutes.users:
        return const UsersPage();
      case AdminRoutes.reviews:
        return const ReviewsPage();
      default:
        return const AnalyticsPage();
    }
  }
}
