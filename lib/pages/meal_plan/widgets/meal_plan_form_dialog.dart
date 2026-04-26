import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/pages/meal_plan/widgets/recipe_picker_dialog.dart';

class MealPlanFormDialog extends StatefulWidget {
  final Map<String, dynamic>? template;

  const MealPlanFormDialog({super.key, this.template});

  bool get isEdit => template != null;

  @override
  State<MealPlanFormDialog> createState() => _MealPlanFormDialogState();
}

class _MealPlanFormDialogState extends State<MealPlanFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  String _status = 'draft';

  final List<String> _days = const [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  final List<String> _mealTypes = const [
    'Sarapan',
    'Makan Siang',
    'Makan Malam',
  ];

  final Map<String, Map<String, String?>> _mealPlan = {};

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.template?['name'] as String? ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.template?['description'] as String? ?? '',
    );

    _status = widget.template?['status'] as String? ?? 'draft';

    _initializeEmptyMealPlan();
    _loadExistingMealPlan();
  }

  void _initializeEmptyMealPlan() {
    for (final day in _days) {
      _mealPlan[day] = {
        'Sarapan': null,
        'Makan Siang': null,
        'Makan Malam': null,
      };
    }
  }

  void _loadExistingMealPlan() {
    final existingMealPlan = widget.template?['mealPlan'];

    if (existingMealPlan is! Map) return;

    for (final day in _days) {
      final existingDayMeals = existingMealPlan[day];

      if (existingDayMeals is Map) {
        for (final mealType in _mealTypes) {
          final value = existingDayMeals[mealType];

          if (value != null && value.toString().trim().isNotEmpty) {
            _mealPlan[day]![mealType] = value.toString();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickRecipe({
    required String day,
    required String mealType,
  }) async {
    final selectedRecipe = await showDialog<String>(
      context: context,
      builder: (_) => const RecipePickerDialog(),
    );

    if (selectedRecipe == null) return;

    setState(() {
      _mealPlan[day]![mealType] = selectedRecipe;
    });
  }

  void _clearRecipe({required String day, required String mealType}) {
    setState(() {
      _mealPlan[day]![mealType] = null;
    });
  }

  void _submit() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty) return;

    Navigator.pop(context, {
      'name': name,
      'description': description,
      'status': _status,
      'mealPlan': _copyMealPlan(),
    });
  }

  Map<String, Map<String, String?>> _copyMealPlan() {
    return _mealPlan.map((day, meals) {
      return MapEntry(
        day,
        meals.map((mealType, recipeName) {
          return MapEntry(mealType, recipeName);
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: SizedBox(
        width: 980,
        height: 720,
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopForm(),
                    const SizedBox(height: AppSizes.spaceL),
                    Text(
                      'Rencana Makan Mingguan *',
                      style: AppTextStyles.smallBold,
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    _buildMealPlanTable(),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      'Klik "Pilih resep" untuk menambahkan resep ke slot waktu makan.',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Row(
        children: [
          Text(
            widget.isEdit
                ? 'Edit Template Meal Plan'
                : 'Tambah Template Meal Plan',
            style: AppTextStyles.h2,
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildTopForm() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Template *', style: AppTextStyles.smallBold),
              const SizedBox(height: AppSizes.spaceS),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Menu Sehat Minggu Ini',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.spaceL),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status', style: AppTextStyles.smallBold),
              const SizedBox(height: AppSizes.spaceS),
              Row(
                children: [
                  Radio<String>(
                    value: 'draft',
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value ?? 'draft';
                      });
                    },
                  ),
                  const Text('Draft'),
                  const SizedBox(width: AppSizes.spaceM),
                  Radio<String>(
                    value: 'published',
                    groupValue: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value ?? 'published';
                      });
                    },
                  ),
                  const Text('Published'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealPlanTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Column(
          children: [
            Container(
              color: AppColors.inputBg,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
                vertical: AppSizes.paddingM,
              ),
              child: const Row(
                children: [
                  Expanded(flex: 1, child: Text('Hari')),
                  Expanded(flex: 2, child: Text('Sarapan')),
                  Expanded(flex: 2, child: Text('Makan Siang')),
                  Expanded(flex: 2, child: Text('Makan Malam')),
                ],
              ),
            ),
            ..._days.map((day) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                  vertical: AppSizes.paddingS,
                ),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        day,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ..._mealTypes.map((mealType) {
                      return Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingXS,
                          ),
                          child: _MealSlotButton(
                            recipeName: _mealPlan[day]![mealType],
                            onTap: () =>
                                _pickRecipe(day: day, mealType: mealType),
                            onClearTap: () =>
                                _clearRecipe(day: day, mealType: mealType),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          const SizedBox(width: AppSizes.spaceM),
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.isEdit ? 'Simpan Perubahan' : 'Tambah Template'),
          ),
        ],
      ),
    );
  }
}

class _MealSlotButton extends StatelessWidget {
  final String? recipeName;
  final VoidCallback onTap;
  final VoidCallback onClearTap;

  const _MealSlotButton({
    required this.recipeName,
    required this.onTap,
    required this.onClearTap,
  });

  bool get _hasRecipe => recipeName != null && recipeName!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _hasRecipe
          ? AppColors.primary.withValues(alpha: 0.12)
          : AppColors.card,
      borderRadius: BorderRadius.circular(AppSizes.radiusS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingS),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            border: Border.all(
              color: _hasRecipe ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _hasRecipe ? recipeName! : 'Pilih resep',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: _hasRecipe
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: _hasRecipe ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (_hasRecipe)
                InkWell(
                  onTap: onClearTap,
                  child: const Icon(
                    Icons.close,
                    size: AppSizes.iconS,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
