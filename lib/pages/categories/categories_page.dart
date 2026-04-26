import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/pages/categories/widgets/category_form_dialog.dart';
import 'package:siresep_admin/pages/categories/widgets/category_group_form_dialog.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<Map<String, dynamic>> _categoryGroups = [
    {'id': 'group_001', 'name': 'Cooking Time', 'isActive': true},
    {'id': 'group_002', 'name': 'Course Type', 'isActive': true},
    {'id': 'group_003', 'name': 'Cuisine', 'isActive': true},
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'cat_001',
      'groupId': 'group_001',
      'name': '<15 menit',
      'recipeCount': 5,
      'isActive': true,
    },
    {
      'id': 'cat_002',
      'groupId': 'group_001',
      'name': '15 menit - 1 jam',
      'recipeCount': 12,
      'isActive': true,
    },
    {
      'id': 'cat_003',
      'groupId': 'group_001',
      'name': '>1 jam',
      'recipeCount': 3,
      'isActive': true,
    },
    {
      'id': 'cat_004',
      'groupId': 'group_002',
      'name': 'Sarapan',
      'recipeCount': 8,
      'isActive': true,
    },
    {
      'id': 'cat_005',
      'groupId': 'group_002',
      'name': 'Makan Siang',
      'recipeCount': 10,
      'isActive': true,
    },
    {
      'id': 'cat_006',
      'groupId': 'group_002',
      'name': 'Makan Malam',
      'recipeCount': 9,
      'isActive': true,
    },
    {
      'id': 'cat_007',
      'groupId': 'group_002',
      'name': 'Dessert',
      'recipeCount': 6,
      'isActive': true,
    },
    {
      'id': 'cat_008',
      'groupId': 'group_003',
      'name': 'Indonesia',
      'recipeCount': 14,
      'isActive': true,
    },
    {
      'id': 'cat_009',
      'groupId': 'group_003',
      'name': 'Asian',
      'recipeCount': 7,
      'isActive': true,
    },
    {
      'id': 'cat_010',
      'groupId': 'group_003',
      'name': 'Western',
      'recipeCount': 5,
      'isActive': true,
    },
  ];

  Future<void> _openAddGroupDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const CategoryGroupFormDialog(),
    );

    if (result == null) return;

    setState(() {
      _categoryGroups.add({
        'id': 'group_${DateTime.now().microsecondsSinceEpoch}',
        ...result,
      });
    });
  }

  Future<void> _openEditGroupDialog(Map<String, dynamic> group) async {
    final index = _categoryGroups.indexOf(group);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => CategoryGroupFormDialog(group: group),
    );

    if (result == null || index == -1) return;

    setState(() {
      _categoryGroups[index] = {'id': group['id'], ...result};
    });
  }

  void _deleteGroup(Map<String, dynamic> group) {
    setState(() {
      _categoryGroups.remove(group);
      _categories.removeWhere((category) => category['groupId'] == group['id']);
    });
  }

  Future<void> _openAddCategoryDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => CategoryFormDialog(groups: _categoryGroups),
    );

    if (result == null) return;

    setState(() {
      _categories.add({
        'id': 'cat_${DateTime.now().microsecondsSinceEpoch}',
        ...result,
      });
    });
  }

  Future<void> _openEditCategoryDialog(Map<String, dynamic> category) async {
    final index = _categories.indexOf(category);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) =>
          CategoryFormDialog(groups: _categoryGroups, category: category),
    );

    if (result == null || index == -1) return;

    setState(() {
      _categories[index] = {
        'id': category['id'],
        'recipeCount': category['recipeCount'],
        ...result,
      };
    });
  }

  void _deleteCategory(Map<String, dynamic> category) {
    setState(() {
      _categories.remove(category);
    });
  }

  void _moveCategory(Map<String, dynamic> category, int direction) {
    final groupId = category['groupId'];
    final groupCategories = _categories
        .where((item) => item['groupId'] == groupId)
        .toList();

    final currentGroupIndex = groupCategories.indexOf(category);
    final targetGroupIndex = currentGroupIndex + direction;

    if (targetGroupIndex < 0 || targetGroupIndex >= groupCategories.length) {
      return;
    }

    final currentGlobalIndex = _categories.indexOf(
      groupCategories[currentGroupIndex],
    );
    final targetGlobalIndex = _categories.indexOf(
      groupCategories[targetGroupIndex],
    );

    setState(() {
      final item = _categories.removeAt(currentGlobalIndex);
      _categories.insert(targetGlobalIndex, item);
    });
  }

  List<Map<String, dynamic>> _categoriesByGroupId(String groupId) {
    return _categories
        .where((category) => category['groupId'] == groupId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSizes.spaceXL),
            _buildInfoBox(),
            const SizedBox(height: AppSizes.spaceL),
            ..._categoryGroups.map((group) {
              final categories = _categoriesByGroupId(group['id'] as String);

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceXL),
                child: _CategoryGroupSection(
                  group: group,
                  categories: categories,
                  onEditGroupTap: () => _openEditGroupDialog(group),
                  onDeleteGroupTap: () => _deleteGroup(group),
                  onEditCategoryTap: _openEditCategoryDialog,
                  onDeleteCategoryTap: _deleteCategory,
                  onMoveUpTap: (category) => _moveCategory(category, -1),
                  onMoveDownTap: (category) => _moveCategory(category, 1),
                ),
              );
            }),
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
              Text('Manajemen Kategori', style: AppTextStyles.h1),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                'Kelola parent/group dan kategori filter yang tampil di aplikasi mobile',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppSizes.buttonHeight,
          child: OutlinedButton.icon(
            onPressed: _openAddGroupDialog,
            icon: const Icon(Icons.create_new_folder_outlined),
            label: const Text('Tambah Group'),
          ),
        ),
        const SizedBox(width: AppSizes.spaceM),
        SizedBox(
          height: AppSizes.buttonHeight,
          child: ElevatedButton.icon(
            onPressed: _categoryGroups.isEmpty ? null : _openAddCategoryDialog,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Kategori'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: 760,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: AppSizes.iconM,
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Text(
              'Admin dapat membuat parent/group sendiri, lalu menambahkan kategori/child di dalamnya.',
              style: AppTextStyles.bodySecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGroupSection extends StatelessWidget {
  final Map<String, dynamic> group;
  final List<Map<String, dynamic>> categories;
  final VoidCallback onEditGroupTap;
  final VoidCallback onDeleteGroupTap;
  final ValueChanged<Map<String, dynamic>> onEditCategoryTap;
  final ValueChanged<Map<String, dynamic>> onDeleteCategoryTap;
  final ValueChanged<Map<String, dynamic>> onMoveUpTap;
  final ValueChanged<Map<String, dynamic>> onMoveDownTap;

  const _CategoryGroupSection({
    required this.group,
    required this.categories,
    required this.onEditGroupTap,
    required this.onDeleteGroupTap,
    required this.onEditCategoryTap,
    required this.onDeleteCategoryTap,
    required this.onMoveUpTap,
    required this.onMoveDownTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = group['isActive'] == true;

    return Container(
      width: 760,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(group['name'] as String, style: AppTextStyles.h2),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(
                        '${categories.length} kategori',
                        style: AppTextStyles.bodySecondary,
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                      _StatusBadge(isActive: isActive),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEditGroupTap,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: onDeleteGroupTap,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Belum ada kategori di group ini.',
                  style: AppTextStyles.bodySecondary,
                ),
              ),
            )
          else
            ...categories.map(
              (category) => _CategoryItem(
                category: category,
                onEditTap: () => onEditCategoryTap(category),
                onDeleteTap: () => onDeleteCategoryTap(category),
                onMoveUpTap: () => onMoveUpTap(category),
                onMoveDownTap: () => onMoveDownTap(category),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onMoveUpTap;
  final VoidCallback onMoveDownTap;

  const _CategoryItem({
    required this.category,
    required this.onEditTap,
    required this.onDeleteTap,
    required this.onMoveUpTap,
    required this.onMoveDownTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = category['isActive'] == true;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              InkWell(
                onTap: onMoveUpTap,
                child: const Icon(
                  Icons.keyboard_arrow_up,
                  color: AppColors.textSecondary,
                ),
              ),
              InkWell(
                onTap: onMoveDownTap,
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSizes.spaceM),
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: const Icon(Icons.tune, color: AppColors.primary),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category['name'] as String,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  '${category['recipeCount']} resep',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          _StatusBadge(isActive: isActive),
          const SizedBox(width: AppSizes.spaceM),
          IconButton(
            onPressed: onEditTap,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: onDeleteTap,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.border,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        isActive ? 'Aktif' : 'Nonaktif',
        style: AppTextStyles.caption.copyWith(
          color: isActive ? AppColors.success : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
