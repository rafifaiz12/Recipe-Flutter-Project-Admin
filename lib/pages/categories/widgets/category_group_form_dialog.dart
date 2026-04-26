import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class CategoryGroupFormDialog extends StatefulWidget {
  final Map<String, dynamic>? group;

  const CategoryGroupFormDialog({super.key, this.group});

  bool get isEdit => group != null;

  @override
  State<CategoryGroupFormDialog> createState() =>
      _CategoryGroupFormDialogState();
}

class _CategoryGroupFormDialogState extends State<CategoryGroupFormDialog> {
  late final TextEditingController _nameController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.group?['name'] as String? ?? '',
    );

    _isActive = widget.group?['isActive'] as bool? ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();

    if (name.isEmpty) return;

    Navigator.pop(context, {'name': name, 'isActive': _isActive});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: SizedBox(
        width: 480,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.isEdit ? 'Edit Group' : 'Tambah Group Baru',
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
              Text('Nama Group *', style: AppTextStyles.smallBold),
              const SizedBox(height: AppSizes.spaceS),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Cooking Time',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSizes.spaceL),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Tampilkan group di aplikasi mobile',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Nonaktifkan jika seluruh group filter belum ingin digunakan.',
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
                      child: const Icon(
                        Icons.folder_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    Text(
                      _nameController.text.trim().isEmpty
                          ? 'Nama Group'
                          : _nameController.text.trim(),
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
                      widget.isEdit ? 'Simpan Perubahan' : 'Tambah Group',
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
