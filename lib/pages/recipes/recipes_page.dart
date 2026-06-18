import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/models/recipe_model.dart';
import 'package:siresep_admin/pages/recipes/widgets/recipe_category_chip.dart';
import 'package:siresep_admin/pages/recipes/widgets/recipe_form_dialog.dart';
import 'package:siresep_admin/pages/recipes/widgets/recipe_status_badge.dart';
import 'package:siresep_admin/providers/recipe_provider.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RecipesView();
  }
}

class _RecipesView extends StatefulWidget {
  const _RecipesView();

  @override
  State<_RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<_RecipesView> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedStatus = 'Semua Status';
  String _selectedCategory = 'Semua Kategori';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddDialog() async {
    final recipeProvider = context.read<RecipeProvider>();

    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: recipeProvider,
        child: const RecipeFormDialog(),
      ),
    );
  }

  Future<void> _openEditDialog(RecipeModel recipe) async {
    final recipeProvider = context.read<RecipeProvider>();

    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: recipeProvider,
        child: RecipeFormDialog(recipe: {'id': recipe.id, ...recipe.toMap()}),
      ),
    );
  }

  Future<void> _deleteRecipe(RecipeModel recipe) async {
    if (recipe.id.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _DeleteRecipeDialog(recipe: recipe),
    );

    if (confirmed != true) return;

    try {
      await context.read<RecipeProvider>().deleteRecipe(recipe.id);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Resep berhasil dihapus.')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus resep: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    if (provider.isLoading && provider.recipes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.recipes.isEmpty) {
      return Center(
        child: Text('Gagal memuat resep: ${provider.errorMessage}'),
      );
    }

    final recipes = provider.recipes;

    final filteredRecipes = provider.filterRecipes(
      searchQuery: _searchQuery,
      selectedStatus: _selectedStatus,
      selectedCategory: _selectedCategory,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSizes.spaceXL),
            _buildFilters(),
            const SizedBox(height: AppSizes.spaceXL),
            _RecipeTable(
              recipes: filteredRecipes,
              onEditTap: _openEditDialog,
              onDeleteTap: _deleteRecipe,
            ),
            const SizedBox(height: AppSizes.spaceL),
            _buildFooter(filteredRecipes.length, recipes.length),
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
              Text('Manajemen Resep', style: AppTextStyles.h1),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                'Kelola semua resep dalam aplikasi',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppSizes.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: _openAddDialog,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Resep'),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.trim();
              });
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cari resep... (min. 3 karakter)',
            ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceL),
        Expanded(
          flex: 2,
          child: _FilterDropdown(
            value: _selectedStatus,
            items: const ['Semua Status', 'Published', 'Draft'],
            onChanged: (value) {
              setState(() => _selectedStatus = value);
            },
          ),
        ),
        const SizedBox(width: AppSizes.spaceL),
        Expanded(
          flex: 2,
          child: _FilterDropdown(
            value: _selectedCategory,
            items: const [
              'Semua Kategori',

              // Dish Type
              'Makanan Utama',
              'Dessert',
              'Minuman',
              'Snack',
              'Appetizer',

              // Cuisine
              'Nusantara',
              'Asian',
              'Western',
              'Middle Eastern',

              // Meal Type
              'Breakfast',
              'Lunch',
              'Dinner',

              // Diet Type
              'Regular',
              'Vegetarian',
              'Vegan',
              'High Protein',
            ],
            onChanged: (value) {
              setState(() => _selectedCategory = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(int filteredCount, int totalCount) {
    return Row(
      children: [
        Text(
          'Menampilkan $filteredCount dari $totalCount resep',
          style: AppTextStyles.bodySecondary,
        ),
        const Spacer(),
        OutlinedButton(onPressed: () {}, child: const Text('Sebelumnya')),
        const SizedBox(width: AppSizes.spaceS),
        ElevatedButton(onPressed: () {}, child: const Text('1')),
        const SizedBox(width: AppSizes.spaceS),
        OutlinedButton(onPressed: () {}, child: const Text('Selanjutnya')),
      ],
    );
  }
}

class _RecipeTable extends StatelessWidget {
  final List<RecipeModel> recipes;
  final ValueChanged<RecipeModel> onEditTap;
  final ValueChanged<RecipeModel> onDeleteTap;

  const _RecipeTable({
    required this.recipes,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Column(
          children: [
            const _RecipeTableHeader(),
            if (recipes.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                child: Text(
                  'Tidak ada resep yang sesuai dengan pencarian.',
                  style: AppTextStyles.bodySecondary,
                ),
              )
            else
              ...recipes.map(
                (recipe) => _RecipeTableRow(
                  recipe: recipe,
                  onEditTap: () => onEditTap(recipe),
                  onDeleteTap: () => onDeleteTap(recipe),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecipeTableHeader extends StatelessWidget {
  const _RecipeTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.inputBg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TableCellText('Judul', flex: 3, isHeader: true),
          _TableCellText('Kategori', flex: 4, isHeader: true),
          _TableCellText('Status', flex: 2, isHeader: true),
          _TableCellText('Rating', flex: 2, isHeader: true),
          _TableCellText('Tanggal Dibuat', flex: 2, isHeader: true),
          _TableCellText('Aksi', flex: 2, isHeader: true),
        ],
      ),
    );
  }
}

String _safeString(dynamic value, {String fallback = '-'}) {
  if (value == null) return fallback;
  final text = value.toString().trim();
  return text.isEmpty ? fallback : text;
}

String _formatDate(dynamic value) {
  if (value == null) return '-';

  if (value is Timestamp) {
    return DateFormat('dd MMM yyyy').format(value.toDate());
  }

  if (value is DateTime) {
    return DateFormat('dd MMM yyyy').format(value);
  }

  final text = value.toString().trim();
  return text.isEmpty ? '-' : text;
}

class _RecipeTableRow extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const _RecipeTableRow({
    required this.recipe,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TableCellText(
            _safeString(recipe.title, fallback: 'Tanpa Judul'),
            flex: 3,
          ),
          Expanded(
            flex: 4,
            child: Wrap(
              spacing: AppSizes.spaceS,
              runSpacing: AppSizes.spaceS,
              children: [
                RecipeCategoryChip(label: recipe.dishType),
                RecipeCategoryChip(label: recipe.cuisine),
                RecipeCategoryChip(label: recipe.mealType),
                RecipeCategoryChip(label: recipe.dietType),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: RecipeStatusBadge(
                status: _safeString(recipe.status, fallback: 'Draft'),
              ),
            ),
          ),
          _TableCellText(
            recipe.reviewCount > 0
                ? '⭐ ${recipe.ratingAverage.toStringAsFixed(1)}'
                : '—',
            flex: 2,
          ),
          _TableCellText(_formatDate(recipe.createdAt), flex: 2),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: onEditTap,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: onDeleteTap,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCellText extends StatelessWidget {
  final String text;
  final int flex;
  final bool isHeader;

  const _TableCellText(this.text, {required this.flex, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSizes.paddingM),
        child: Text(
          text,
          maxLines: isHeader ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style: isHeader
              ? AppTextStyles.smallBold.copyWith(fontSize: 15)
              : AppTextStyles.body,
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(),
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _DeleteRecipeDialog extends StatelessWidget {
  final RecipeModel recipe;

  const _DeleteRecipeDialog({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: SizedBox(
        width: 560,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Hapus Resep', style: AppTextStyles.h2),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceL),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  'Tindakan Permanen\n\n'
                  'Penghapusan resep akan menghapus:\n'
                  '• Data resep dari Firestore\n'
                  '• Resep dari daftar aplikasi mobile\n'
                  '• Data bahan dan langkah memasak\n'
                  '• Gambar URL yang tersimpan pada resep',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.error,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text(
                'Apakah Anda yakin ingin menghapus resep ini?',
                style: AppTextStyles.smallBold,
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                recipe.title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '⚠ Tindakan ini tidak dapat dibatalkan. Pastikan Anda yakin sebelum melanjutkan.',
                  style: AppTextStyles.bodySecondary,
                ),
              ),
              const SizedBox(height: AppSizes.spaceXL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Hapus Permanen'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
