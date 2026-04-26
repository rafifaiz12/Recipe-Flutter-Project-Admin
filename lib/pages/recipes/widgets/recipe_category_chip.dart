import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class RecipeCategoryChip extends StatelessWidget {
  final String label;

  const RecipeCategoryChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
