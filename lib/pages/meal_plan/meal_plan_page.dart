import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/pages/meal_plan/widgets/meal_plan_form_dialog.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  final List<Map<String, dynamic>> _templates = [
    {
      'id': 'template_001',
      'name': 'Healthy Weekly Menu',
      'description': 'A combination of healthy and nutritious meals for a week',
      'status': 'published',
      'mealPlan': <String, Map<String, String?>>{},
    },
    {
      'id': 'template_002',
      'name': 'Traditional Indonesian Menu',
      'description': 'Enjoy Indonesian flavors throughout the week',
      'status': 'published',
      'mealPlan': <String, Map<String, String?>>{},
    },
    {
      'id': 'template_003',
      'name': 'Favorite Western Menu',
      'description': 'Easy-to-make western dishes at home',
      'status': 'draft',
      'mealPlan': <String, Map<String, String?>>{},
    },
  ];

  String _selectedStatus = 'All Status';

  List<Map<String, dynamic>> get _filteredTemplates {
    if (_selectedStatus == 'All Status') {
      return _templates;
    }

    return _templates
        .where(
          (template) => template['status'] == _selectedStatus.toLowerCase(),
    )
        .toList();
  }

  Future<void> _openForm({Map<String, dynamic>? template}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => MealPlanFormDialog(template: template),
    );

    if (result == null) return;

    setState(() {
      if (template == null) {
        _templates.add({
          'id': 'template_${DateTime.now().microsecondsSinceEpoch}',
          ...result,
        });
      } else {
        final index = _templates.indexOf(template);
        if (index != -1) {
          _templates[index] = {'id': template['id'], ...result};
        }
      }
    });
  }

  void _deleteTemplate(Map<String, dynamic> template) {
    setState(() {
      _templates.remove(template);
    });
  }

  @override
  Widget build(BuildContext context) {
    final templates = _filteredTemplates;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSizes.spaceL),
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: 'All Status',
                    child: Text('All Status'),
                  ),
                  DropdownMenuItem(
                    value: 'Published',
                    child: Text('Published'),
                  ),
                  DropdownMenuItem(value: 'Draft', child: Text('Draft')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
            ),
            const SizedBox(height: AppSizes.spaceXL),
            Wrap(
              spacing: AppSizes.spaceL,
              runSpacing: AppSizes.spaceL,
              children: templates.map(_buildTemplateCard).toList(),
            ),
          ],
        ),
      ),
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

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    final bool isPublished = template['status'] == 'published';
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
          Text(
            template['name'] as String,
            style: AppTextStyles.h2.copyWith(fontSize: 18),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            (template['description'] as String?)?.isNotEmpty == true
                ? template['description'] as String
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

  int _countSelectedMeals(Map<String, dynamic> template) {
    final rawMealPlan = template['mealPlan'];

    if (rawMealPlan is! Map) return 0;

    int count = 0;

    for (final dayMeals in rawMealPlan.values) {
      if (dayMeals is Map) {
        for (final recipeName in dayMeals.values) {
          if (recipeName != null && recipeName.toString().trim().isNotEmpty) {
            count++;
          }
        }
      }
    }

    return count;
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
