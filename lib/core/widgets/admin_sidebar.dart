import 'package:flutter/material.dart';
import 'package:siresep_admin/app/admin_routes.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/core/widgets/admin_sidebar_item.dart';

class AdminSidebar extends StatelessWidget {
  final String currentRoute;

  const AdminSidebar({super.key, required this.currentRoute});

  void _goTo(BuildContext context, String route) {
    if (currentRoute == route) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 284,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Dashboard', style: AppTextStyles.h2),
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  'Kelola data aplikasi',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border),
          AdminSidebarItem(
            icon: Icons.analytics_outlined,
            label: 'Analytics',
            isSelected: currentRoute == AdminRoutes.analytics,
            onTap: () => _goTo(context, AdminRoutes.analytics),
          ),
          AdminSidebarItem(
            icon: Icons.book_outlined,
            label: 'Resep',
            isSelected: currentRoute == AdminRoutes.recipes,
            onTap: () => _goTo(context, AdminRoutes.recipes),
          ),
          AdminSidebarItem(
            icon: Icons.sell_outlined,
            label: 'Kategori',
            isSelected: currentRoute == AdminRoutes.categories,
            onTap: () => _goTo(context, AdminRoutes.categories),
          ),
          AdminSidebarItem(
            icon: Icons.calendar_month_outlined,
            label: 'Meal Plan',
            isSelected: currentRoute == AdminRoutes.mealPlan,
            onTap: () => _goTo(context, AdminRoutes.mealPlan),
          ),
          AdminSidebarItem(
            icon: Icons.group_outlined,
            label: 'Pengguna',
            isSelected: currentRoute == AdminRoutes.users,
            onTap: () => _goTo(context, AdminRoutes.users),
          ),
          AdminSidebarItem(
            icon: Icons.chat_bubble_outline,
            label: 'Review',
            isSelected: currentRoute == AdminRoutes.reviews,
            onTap: () => _goTo(context, AdminRoutes.reviews),
          ),
          const Spacer(),
          const Divider(color: AppColors.border),
          AdminSidebarItem(
            icon: Icons.logout,
            label: 'Logout',
            isSelected: false,
            onTap: () =>
                Navigator.pushReplacementNamed(context, AdminRoutes.login),
          ),
          const SizedBox(height: AppSizes.spaceM),
        ],
      ),
    );
  }
}
