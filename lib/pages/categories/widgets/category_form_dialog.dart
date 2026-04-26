import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class CategoryFormDialog extends StatefulWidget {
  final List<Map<String, dynamic>> groups;
  final Map<String, dynamic>? category;

  const CategoryFormDialog({super.key, required this.groups, this.category});

  bool get isEdit => category != null;

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  late final TextEditingController _nameController;
  late String _selectedGroupId;
  late bool _isActive;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.category?['name'] as String? ?? '',
    );

    _selectedGroupId =
        widget.category?['groupId'] as String? ??
        widget.groups.first['id'] as String;

    _isActive = widget.category?['isActive'] as bool? ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _groupNameById(String id) {
    final group = widget.groups.firstWhere(
      (item) => item['id'] == id,
      orElse: () => widget.groups.first,
    );

    return group['name'] as String;
  }

  void _submit() {
    final name = _nameController.text.trim();

    if (name.isEmpty) return;

    Navigator.pop(context, {
      'name': name,
      'groupId': _selectedGroupId,
      'recipeCount': widget.category?['recipeCount'] ?? 0,
      'isActive': _isActive,
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
        width: 520,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.isEdit ? 'Edit Kategori' : 'Tambah Kategori Baru',
                    style: AppTextStyles.h2,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text('Nama Kategori *', style: AppTextStyles.smallBold),
              const SizedBox(height: AppSizes.spaceS),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Contoh: Sarapan'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text('Parent / Group *', style: AppTextStyles.smallBold),
              const SizedBox(height: AppSizes.spaceS),
              DropdownButtonFormField<String>(
                value: _selectedGroupId,
                isExpanded: true,
                decoration: const InputDecoration(),
                items: widget.groups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group['id'] as String,
                    child: Text(group['name'] as String),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedGroupId = value;
                  });
                },
              ),
              const SizedBox(height: AppSizes.spaceL),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Tampilkan di aplikasi mobile',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Nonaktifkan jika kategori belum ingin digunakan user.',
                  style: AppTextStyles.bodySecondary,
                ),
                value: _isActive,
                activeThumbColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
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
                child: Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                      child: const Icon(Icons.tune, color: AppColors.primary),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text.trim().isEmpty
                              ? 'Nama Kategori'
                              : _nameController.text.trim(),
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceXS),
                        Text(
                          _groupNameById(_selectedGroupId),
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceXL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      widget.isEdit ? 'Simpan Perubahan' : 'Tambah Kategori',
                    ),
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
