import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/models/meal_plan_model.dart';
import 'package:siresep_admin/providers/meal_plan_provider.dart';
import 'package:siresep_admin/pages/meal_plan/widgets/meal_plan_form_dialog.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  String _selectedStatus = 'All Status';

  List<MealPlanTemplateModel> _filterTemplates(
    List<MealPlanTemplateModel> templates,
  ) {
    if (_selectedStatus == 'All Status') return templates;

    return templates
        .where((template) => template.status == _selectedStatus.toLowerCase())
        .toList();
  }

  Future<void> _openForm({MealPlanTemplateModel? template}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => MealPlanFormDialog(
        template: template == null
            ? null
            : {
                'id': template.id,
                'name': template.name,
                'description': template.description,
                'status': template.status,
                'mealPlan': template.mealPlan,
              },
      ),
    );

    if (result == null || !mounted) return;

    final provider = context.read<MealPlanTemplateProvider>();

    final newTemplate = MealPlanTemplateModel(
      id: template?.id ?? '',
      name: result['name']?.toString() ?? '',
      description: result['description']?.toString() ?? '',
      status: result['status']?.toString() ?? 'draft',
      mealPlan: _parseMealPlan(result['mealPlan']),
    );

    try {
      if (template == null) {
        await provider.createTemplate(newTemplate);
      } else {
        await provider.updateTemplate(newTemplate);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            template == null
                ? 'Template meal plan berhasil ditambahkan.'
                : 'Template meal plan berhasil diperbarui.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan template: $error')),
      );
    }
  }

  Future<void> _deleteTemplate(MealPlanTemplateModel template) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Template?'),
        content: Text(
          'Template "${template.name}" akan dihapus dari Firestore.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      await context.read<MealPlanTemplateProvider>().deleteTemplate(
        template.id,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Template meal plan berhasil dihapus.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus template: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealPlanTemplateProvider>(
      builder: (context, provider, _) {
        final templates = _filterTemplates(provider.templates);

        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: AppSizes.spaceL),
                _buildStatusFilter(),
                const SizedBox(height: AppSizes.spaceXL),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (provider.errorMessage != null)
                  Text(
                    'Gagal memuat template: ${provider.errorMessage}',
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  )
                else if (templates.isEmpty)
                  Text(
                    'Belum ada template meal plan.',
                    style: AppTextStyles.bodySecondary,
                  )
                else
                  Wrap(
                    spacing: AppSizes.spaceL,
                    runSpacing: AppSizes.spaceL,
                    children: templates.map(_buildTemplateCard).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Template Meal Plan', style: AppTextStyles.h1),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                'Create weekly meal plan templates for users',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppSizes.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Template'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        isExpanded: true,
        items: const [
          DropdownMenuItem(value: 'All Status', child: Text('All Status')),
          DropdownMenuItem(value: 'Published', child: Text('Published')),
          DropdownMenuItem(value: 'Draft', child: Text('Draft')),
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            _selectedStatus = value;
          });
        },
      ),
    );
  }

  Widget _buildTemplateCard(MealPlanTemplateModel template) {
    final bool isPublished = template.status == 'published';
    final mealCount = _countSelectedMeals(template);

    return Container(
      width: 380,
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: const Icon(Icons.calendar_month_outlined),
              ),
              const Spacer(),
              _StatusBadge(isPublished: isPublished),
            ],
          ),
          const SizedBox(height: AppSizes.spaceL),
          Text(template.name, style: AppTextStyles.h2.copyWith(fontSize: 18)),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            template.description.isNotEmpty
                ? template.description
                : 'No description available',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            '$mealCount recipe slots filled',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          const Divider(color: AppColors.border),
          Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () => _openForm(template: template),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => _deleteTemplate(template),
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _countSelectedMeals(MealPlanTemplateModel template) {
    int count = 0;

    for (final dayMeals in template.mealPlan.values) {
      for (final recipeId in dayMeals.values) {
        if (recipeId != null && recipeId.trim().isNotEmpty) {
          count++;
        }
      }
    }

    return count;
  }

  Map<String, Map<String, String?>> _parseMealPlan(dynamic value) {
    final result = <String, Map<String, String?>>{};

    if (value is! Map) return result;

    for (final dayEntry in value.entries) {
      final day = dayEntry.key.toString();
      final meals = <String, String?>{};

      if (dayEntry.value is Map) {
        final rawMeals = dayEntry.value as Map;

        for (final mealEntry in rawMeals.entries) {
          meals[mealEntry.key.toString()] = mealEntry.value?.toString();
        }
      }

      result[day] = meals;
    }

    return result;
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isPublished;

  const _StatusBadge({required this.isPublished});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: isPublished
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.warning.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        isPublished ? 'Published' : 'Draft',
        style: AppTextStyles.caption.copyWith(
          color: isPublished ? AppColors.success : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
