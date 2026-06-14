import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/models/recipe_model.dart';
import 'package:siresep_admin/providers/recipe_provider.dart';

class RecipePickerDialog extends StatefulWidget {
  const RecipePickerDialog({super.key});

  @override
  State<RecipePickerDialog> createState() => _RecipePickerDialogState();
}

class _RecipePickerDialogState extends State<RecipePickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RecipeModel> _filterRecipes(List<RecipeModel> recipes) {
    final query = _query.toLowerCase();

    if (query.isEmpty) return recipes;

    return recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(query);
    }).toList();
  }

  void _selectRecipe(RecipeModel recipe) {
    Navigator.pop(context, recipe);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        final recipes = _filterRecipes(provider.recipes);

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
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.errorMessage != null
                      ? Center(
                          child: Text(
                            'Gagal memuat resep.',
                            style: AppTextStyles.bodySecondary,
                          ),
                        )
                      : recipes.isEmpty
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
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusM,
                              ),
                              child: InkWell(
                                onTap: () => _selectRecipe(recipe),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                    AppSizes.paddingM,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusM,
                                    ),
                                  ),
                                  child: Text(
                                    recipe.title,
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
      },
    );
  }
}
