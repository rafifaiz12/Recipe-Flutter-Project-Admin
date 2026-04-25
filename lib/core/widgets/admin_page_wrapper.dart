import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class AdminPageWrapper extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? child;

  const AdminPageWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h1),
          const SizedBox(height: AppSizes.spaceS),
          Text(subtitle, style: AppTextStyles.bodySecondary),
          const SizedBox(height: AppSizes.spaceXL),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(color: AppColors.border),
              ),
              child:
                  child ??
                  Center(
                    child: Text(
                      'Konten halaman akan dibuat setelah desain final.',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
