import 'package:flutter/material.dart';
import 'package:siresep_admin/app/admin_routes.dart';
import 'package:siresep_admin/app/admin_theme.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiResep Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.lightTheme,
      initialRoute: AdminRoutes.login,
      routes: AdminRoutes.routes,
    );
  }
}
