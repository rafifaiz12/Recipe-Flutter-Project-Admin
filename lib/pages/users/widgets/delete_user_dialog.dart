import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class DeleteUserDialog extends StatefulWidget {
  final Map<String, dynamic> user;

  const DeleteUserDialog({super.key, required this.user});

  @override
  State<DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  final TextEditingController _emailController = TextEditingController();

  bool get _isValid =>
      _emailController.text.trim() == widget.user['email'] as String;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_isValid) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.user['email'] as String;
    final reviewCount = widget.user['reviewCount'];

    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: SizedBox(
        width: 460,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Delete User Account', style: AppTextStyles.h2),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceL),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.28),
                  ),
                ),
                child: Text(
                  'Permanent Action\and Account Deletion will delete:\n'
                  '• Firebase authentication data\n'
                  '• All favorites, meal plans, and shopping lists\n'
                  '• All reviews ($reviewCount review)\n'
                  '• Recipe rating will be recalculated',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.error,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Retype email to confirm *',
                  style: AppTextStyles.smallBold,
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              TextField(
                controller: _emailController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(hintText: email),
              ),
              const SizedBox(height: AppSizes.spaceM),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '⚠️ This action cannot be undone. Please make sure you are sure before proceeding.',
                  style: AppTextStyles.bodySecondary,
                ),
              ),
              const SizedBox(height: AppSizes.spaceXL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  ElevatedButton(
                    onPressed: _isValid ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.error.withValues(
                        alpha: 0.35,
                      ),
                      disabledForegroundColor: Colors.white,
                    ),
                    child: const Text('Permanent Delete'),
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
