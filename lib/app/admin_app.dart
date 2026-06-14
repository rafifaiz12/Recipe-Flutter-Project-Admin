import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siresep_admin/app/admin_routes.dart';
import 'package:siresep_admin/app/admin_theme.dart';
import 'package:siresep_admin/providers/auth_provider.dart';
import 'package:siresep_admin/providers/recipe_provider.dart';
import 'package:siresep_admin/providers/user_provider.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecipeProvider()..listenRecipes(),
        ),
        ChangeNotifierProvider(create: (_) => AdminAuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()..listenUsers()),
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
