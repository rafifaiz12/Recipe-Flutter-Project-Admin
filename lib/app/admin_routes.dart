import 'package:flutter/material.dart';
import 'package:siresep_admin/core/widgets/admin_shell.dart';
import 'package:siresep_admin/pages/auth/admin_login_page.dart';

class AdminRoutes {
  static const String login = '/login';
  static const String analytics = '/analytics';
  static const String recipes = '/recipes';
  static const String mealPlan = '/meal-plan';
  static const String users = '/users';
  static const String reviews = '/reviews';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const AdminLoginPage(),
      analytics: (context) => const AdminShell(currentRoute: analytics),
      recipes: (context) => const AdminShell(currentRoute: recipes),
      mealPlan: (context) => const AdminShell(currentRoute: mealPlan),
      users: (context) => const AdminShell(currentRoute: users),
      reviews: (context) => const AdminShell(currentRoute: reviews),
    };
  }
}
