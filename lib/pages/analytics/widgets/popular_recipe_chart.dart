import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class PopularRecipeChart extends StatelessWidget {
  const PopularRecipeChart({super.key});

  static const List<Map<String, dynamic>> _items = [
    {'name': 'Nasi Goreng', 'value': 240},
    {'name': 'Rendang', 'value': 195},
    {'name': 'Soto Ayam', 'value': 172},
    {'name': 'Ayam Bakar', 'value': 150},
    {'name': 'Gado-Gado', 'value': 138},
    {'name': 'Spaghetti', 'value': 126},
    {'name': 'Nasi Kuning', 'value': 112},
    {'name': 'Pecel Lele', 'value': 96},
    {'name': 'Teriyaki', 'value': 84},
    {'name': 'Pizza', 'value': 74},
  ];

  @override
  Widget build(BuildContext context) {
    const double maxValue = 260;
    const double chartHeight = 240;

    return SizedBox(
      height: 340,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _items.map((item) {
          final double value = (item['value'] as int).toDouble();
          final double barHeight = (value / maxValue) * chartHeight;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingXS,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // VALUE (angka di atas bar)
                  Text(
                    value.toInt().toString(),
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: AppSizes.spaceXS),

                  // BAR
                  Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                  ),

                  const SizedBox(height: AppSizes.spaceS),

                  // LABEL
                  Text(
                    item['name'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
