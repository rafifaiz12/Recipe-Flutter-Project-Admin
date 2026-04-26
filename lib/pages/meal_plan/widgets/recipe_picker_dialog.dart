import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class RecipePickerDialog extends StatefulWidget {
  const RecipePickerDialog({super.key});

  @override
  State<RecipePickerDialog> createState() => _RecipePickerDialogState();
}

class _RecipePickerDialogState extends State<RecipePickerDialog> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  final List<String> _recipes = const [
    'Nasi Goreng Spesial',
    'Rendang Daging Sapi',
    'Soto Ayam',
    'Ayam Bakar',
    'Gado-Gado',
    'Spaghetti Carbonara',
    'Chicken Teriyaki',
    'Nasi Kuning',
    'Pecel Lele',
    'Pizza Margherita',
  ];

  List<String> get _filteredRecipes {
    if (_query.isEmpty) {
      return _recipes;
    }

    return _recipes
        .where((recipe) => recipe.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectRecipe(String recipeName) {
    Navigator.pop(context, recipeName);
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _filteredRecipes;

    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: SizedBox(
        width: 430,
        height: 520,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Row(
                children: [
                  Text('Choose Recipe', style: AppTextStyles.h2),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _query = value.trim();
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Find recipe...',
                ),
              ),
            ),
            Expanded(
              child: recipes.isEmpty
                  ? Center(
                child: Text(
                  'Recipe not found.',
                  style: AppTextStyles.bodySecondary,
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.paddingL,
                  0,
                  AppSizes.paddingL,
                  AppSizes.paddingL,
                ),
                itemCount: recipes.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: AppSizes.spaceS),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];

                  return Material(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    child: InkWell(
                      onTap: () => _selectRecipe(recipe),
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusM,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.paddingM),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusM,
                          ),
                        ),
                        child: Text(
                          recipe,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
