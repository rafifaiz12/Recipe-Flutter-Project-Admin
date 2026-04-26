import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class AnalyticsSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const AnalyticsSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodySecondary),
          const SizedBox(height: AppSizes.spaceM),
          Text(value, style: AppTextStyles.h2),
          const SizedBox(height: AppSizes.spaceS),
          Text(subtitle, style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}
