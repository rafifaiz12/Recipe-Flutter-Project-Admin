import 'package:flutter/material.dart';
import 'package:siresep_admin/app/admin_routes.dart';
import 'package:siresep_admin/app/admin_theme.dart';
import 'package:provider/provider.dart';
import 'package:siresep_admin/providers/recipe_provider.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecipeProvider()..listenRecipes(),
        ),
      ],
      child: MaterialApp(
        title: 'SiResep Admin',
        debugShowCheckedModeBanner: false,
        theme: AdminTheme.lightTheme,
        initialRoute: AdminRoutes.login,
        routes: AdminRoutes.routes,
      ),
    );
  }
}
