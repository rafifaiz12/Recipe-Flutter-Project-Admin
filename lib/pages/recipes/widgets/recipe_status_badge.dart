import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class RecipeStatusBadge extends StatelessWidget {
  final String status;

  const RecipeStatusBadge({super.key, required this.status});

  bool get _isPublished => status == 'Published';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: _isPublished
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.warning.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: _isPublished ? AppColors.success : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
