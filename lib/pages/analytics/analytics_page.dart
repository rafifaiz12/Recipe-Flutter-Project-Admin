import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/pages/analytics/widgets/analytics_stat_card.dart';
import 'package:siresep_admin/pages/analytics/widgets/analytics_summary_card.dart';
import 'package:siresep_admin/pages/analytics/widgets/popular_recipe_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics & Laporan', style: AppTextStyles.h1),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            'Statistik dan insight penggunaan aplikasi',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: AppSizes.spaceXL),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.refresh,
                  color: AppColors.textSecondary,
                  size: AppSizes.iconM,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  'Terakhir diperbarui: 2026-04-12 08:00',
                  style: AppTextStyles.bodySecondary,
                ),
                const Spacer(),
                Text(
                  'Data di-refresh otomatis setiap 24 jam',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceL),

          const Row(
            children: [
              Expanded(
                child: AnalyticsStatCard(
                  icon: Icons.group_outlined,
                  iconBackgroundColor: Color(0xFFE0ECFF),
                  iconColor: Color(0xFF2563EB),
                  label: 'Total Pengguna',
                  value: '1,247',
                ),
              ),
              SizedBox(width: AppSizes.spaceL),
              Expanded(
                child: AnalyticsStatCard(
                  icon: Icons.book_outlined,
                  iconBackgroundColor: Color(0xFFDCFCE7),
                  iconColor: AppColors.success,
                  label: 'Total Resep Published',
                  value: '156',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spaceL),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resep Terpopuler', style: AppTextStyles.h2),
                SizedBox(height: AppSizes.spaceS),
                Text(
                  'Top 10 resep paling banyak difavoritkan pengguna',
                  style: AppTextStyles.bodySecondary,
                ),
                SizedBox(height: AppSizes.spaceXL),
                PopularRecipeChart(),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceL),

          const Row(
            children: [
              Expanded(
                child: AnalyticsSummaryCard(
                  title: 'Kategori Terpopuler',
                  value: 'Makanan Utama',
                  subtitle: '328 favorites total',
                ),
              ),
              SizedBox(width: AppSizes.spaceL),
              Expanded(
                child: AnalyticsSummaryCard(
                  title: 'Rata-rata Rating',
                  value: '4.6 ⭐',
                  subtitle: 'Dari 892 review',
                ),
              ),
              SizedBox(width: AppSizes.spaceL),
              Expanded(
                child: AnalyticsSummaryCard(
                  title: 'Template Meal Plan Aktif',
                  value: '12',
                  subtitle: '8 published, 4 draft',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spaceXL),
        ],
      ),
    );
  }
}
