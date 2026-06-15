import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:siresep_admin/app/admin_app.dart';
import 'package:siresep_admin/providers/meal_plan_provider.dart';
import 'package:siresep_admin/providers/review_provider.dart';
import 'package:siresep_admin/providers/recipe_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MealPlanTemplateProvider()..listenTemplates(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecipeProvider()..listenRecipes(),
        ),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: const AdminApp(),
    ),
  );
}
