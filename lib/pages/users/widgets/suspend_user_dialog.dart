import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class SuspendUserDialog extends StatefulWidget {
  final Map<String, dynamic> user;

  const SuspendUserDialog({super.key, required this.user});

  @override
  State<SuspendUserDialog> createState() => _SuspendUserDialogState();
}

class _SuspendUserDialogState extends State<SuspendUserDialog> {
  String _reason = 'Spam';

  final List<String> _reasons = const [
    'Spam',
    'Konten Tidak Pantas',
    'Permintaan Pengguna',
    'Lainnya',
  ];

  void _submit() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.user['email'] as String;

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
                  Text('Suspend Akun', style: AppTextStyles.h2),
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
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primary),
                    const SizedBox(width: AppSizes.spaceM),
                    Expanded(
                      child: Text(
                        'Akun $email akan di-suspend dan tidak dapat login ke aplikasi mobile.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Alasan Suspend *', style: AppTextStyles.smallBold),
              ),
              const SizedBox(height: AppSizes.spaceS),
              DropdownButtonFormField<String>(
                value: _reason,
                isExpanded: true,
                items: _reasons.map((reason) {
                  return DropdownMenuItem(value: reason, child: Text(reason));
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _reason = value);
                },
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Suspend Akun'),
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
