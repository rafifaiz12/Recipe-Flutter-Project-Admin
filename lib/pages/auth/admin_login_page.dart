import 'package:flutter/material.dart';
import 'package:siresep_admin/app/admin_routes.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  void _login(BuildContext context) {
    Navigator.pushReplacementNamed(context, AdminRoutes.analytics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SizedBox(
          width: 520,
          child: Card(
            color: AppColors.card,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              side: const BorderSide(color: AppColors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingXL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Dashboard',
                    style: AppTextStyles.h1.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Text(
                    'Masuk untuk mengelola data aplikasi',
                    style: AppTextStyles.bodySecondary,
                  ),
                  const SizedBox(height: AppSizes.spaceXL),
                  Text('Email', style: AppTextStyles.smallBold),
                  const SizedBox(height: AppSizes.spaceS),
                  const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'admin@example.com',
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  Text('Password', style: AppTextStyles.smallBold),
                  const SizedBox(height: AppSizes.spaceS),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceL),
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => _login(context),
                      child: const Text('Masuk'),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceL),
                  Center(
                    child: Text(
                      'Demo: admin@example.com / admin123',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
