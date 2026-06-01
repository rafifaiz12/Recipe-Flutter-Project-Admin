import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siresep_admin/services/recipe_service.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/pages/recipes/widgets/recipe_category_chip.dart';
import 'package:siresep_admin/pages/recipes/widgets/recipe_form_dialog.dart';
import 'package:siresep_admin/pages/recipes/widgets/recipe_status_badge.dart';
import 'package:intl/intl.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  final RecipeService _recipeService = RecipeService();

  String _searchQuery = '';
  String _selectedStatus = 'Semua Status';
  String _selectedCategory = 'Semua Kategori';

  final List<Map<String, dynamic>> _recipes = [
    {
      'title': 'Nasi Goreng Spesial',
      'description': 'Nasi goreng khas Indonesia dengan bumbu spesial.',
      'categories': ['Makanan Utama', 'Nusantara'],
      'ingredients': [
        {'name': 'Nasi', 'quantity': '2', 'unit': 'porsi'},
        {'name': 'Telur', 'quantity': '1', 'unit': 'butir'},
      ],
      'steps': ['Tumis bumbu.', 'Masukkan nasi dan aduk rata.'],
      'status': 'Draft',
      'rating': '4.5',
      'createdAt': '2026-04-10',
    },
    {
      'title': 'Rendang Daging Sapi',
      'description': 'Rendang daging sapi dengan bumbu rempah.',
      'categories': ['Makanan Utama', 'Nusantara'],
      'ingredients': [
        {'name': 'Daging sapi', 'quantity': '500', 'unit': 'g'},
      ],
      'steps': ['Masak daging bersama bumbu.', 'Masak hingga empuk.'],
      'status': 'Published',
      'rating': '4.8',
      'createdAt': '2026-04-09',
    },
    {
      'title': 'Rawon',
      'description': 'Rawon khas Nusantara.',
      'categories': ['Makanan Utama', 'Nusantara'],
      'ingredients': [
        {'name': 'Daging sapi', 'quantity': '300', 'unit': 'g'},
      ],
      'steps': ['Masak bumbu.', 'Masukkan daging.'],
      'status': 'Published',
      'rating': '—',
      'createdAt': '2026-04-12',
    },
  ];

  List<Map<String, dynamic>> _filterRecipes(
    List<Map<String, dynamic>> recipes,
  ) {
    return recipes.where((recipe) {
      final title = (recipe['title'] ?? '').toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      final categories = List<String>.from(recipe['categories'] as List? ?? []);
      final status = (recipe['status'] ?? '').toString();

      final matchesSearch = query.isEmpty || title.contains(query);
      final matchesStatus =
          _selectedStatus == 'Semua Status' || status == _selectedStatus;
      final matchesCategory =
          _selectedCategory == 'Semua Kategori' ||
          categories.contains(_selectedCategory);

      return matchesSearch && matchesStatus && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddDialog() async {
    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const RecipeFormDialog(),
    );
  }

  Future<void> _openEditDialog(Map<String, dynamic> recipe) async {
    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => RecipeFormDialog(recipe: recipe),
    );
  }

  Future<void> _deleteRecipe(Map<String, dynamic> recipe) async {
    final id = recipe['id']?.toString();

    if (id == null || id.isEmpty) return;

    await _recipeService.deleteRecipe(id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _recipeService.getRecipes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Gagal memuat resep: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final recipes =
            snapshot.data?.docs.map((doc) {
              final data = doc.data();
              return {'id': doc.id, ...data};
            }).toList() ??
            [];

        final filteredRecipes = _filterRecipes(recipes);

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
              'Makanan Utama',
              'Nusantara',
              'Western',
              'Dessert',
              'Minuman',
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
  final List<Map<String, dynamic>> recipes;
  final ValueChanged<Map<String, dynamic>> onEditTap;
  final ValueChanged<Map<String, dynamic>> onDeleteTap;

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

List<String> _safeStringList(dynamic value) {
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return [];
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
  final Map<String, dynamic> recipe;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const _RecipeTableRow({
    required this.recipe,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = _safeStringList(recipe['categories']);

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
            _safeString(recipe['title'], fallback: 'Tanpa Judul'),
            flex: 3,
          ),
          Expanded(
            flex: 4,
            child: Wrap(
              spacing: AppSizes.spaceS,
              runSpacing: AppSizes.spaceS,
              children: categories
                  .map((category) => RecipeCategoryChip(label: category))
                  .toList(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: RecipeStatusBadge(
                status: _safeString(recipe['status'], fallback: 'Draft'),
              ),
            ),
          ),
          _TableCellText(
            _safeString(recipe['rating'], fallback: '—') == '—'
                ? '—'
                : '⭐ ${_safeString(recipe['rating'])}',
            flex: 2,
          ),
          _TableCellText(_formatDate(recipe['createdAt']), flex: 2),
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
