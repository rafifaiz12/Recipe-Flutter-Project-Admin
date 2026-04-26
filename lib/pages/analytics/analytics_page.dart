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
          Text('Analytics & Reports', style: AppTextStyles.h1),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            'Application Usage Statistics and Insights',
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
                  'Last updated: 2026-04-12 08:00',
                  style: AppTextStyles.bodySecondary,
                ),
                const Spacer(),
                Text(
                  'Data refreshes every 24 hours automatically',
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
                  label: 'Total Users',
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
                Text('Most Popular Recipes', style: AppTextStyles.h2),
                SizedBox(height: AppSizes.spaceS),
                Text(
                  'Top 10 Most Favorited Recipes by Users',
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
                  title: 'Most Popular Categories',
                  value: 'Main Courses',
                  subtitle: '328 Total Favorites',
                ),
              ),
              SizedBox(width: AppSizes.spaceL),
              Expanded(
                child: AnalyticsSummaryCard(
                  title: 'Average Rating',
                  value: '4.6 ⭐',
                  subtitle: 'From 892 Reviews',
                ),
              ),
              SizedBox(width: AppSizes.spaceL),
              Expanded(
                child: AnalyticsSummaryCard(
                  title: 'Active Meal Plan Templates',
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
