import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/models/user_model.dart';
import 'package:siresep_admin/providers/user_provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String _selectedStatus = 'Semua Status';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    if (userProvider.isLoading && userProvider.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.errorMessage != null && userProvider.users.isEmpty) {
      return Center(
        child: Text('Gagal memuat pengguna: ${userProvider.errorMessage}'),
      );
    }

    final users = userProvider.filterUsers(
      query: _query,
      selectedStatus: _selectedStatus,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manajemen Pengguna', style: AppTextStyles.h1),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              'Kelola akun pengguna aplikasi',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: AppSizes.spaceXL),
            _buildFilters(),
            const SizedBox(height: AppSizes.spaceXL),
            _UsersTable(users: users),
            const SizedBox(height: AppSizes.spaceL),
            _buildFooter(
              filteredCount: users.length,
              totalCount: userProvider.users.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() => _query = value.trim());
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cari berdasarkan nama atau email...',
            ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceL),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: _selectedStatus,
            isExpanded: true,
            items: const [
              DropdownMenuItem(
                value: 'Semua Status',
                child: Text('Semua Status'),
              ),
              DropdownMenuItem(value: 'Aktif', child: Text('Aktif')),
              DropdownMenuItem(value: 'Suspended', child: Text('Suspended')),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedStatus = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooter({required int filteredCount, required int totalCount}) {
    return Row(
      children: [
        Text(
          'Menampilkan $filteredCount dari $totalCount pengguna',
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

class _UsersTable extends StatelessWidget {
  final List<AdminUserModel> users;

  const _UsersTable({required this.users});

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
            Container(
              color: AppColors.inputBg,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingM,
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TableText('Nama', flex: 2, isHeader: true),
                  _TableText('Email', flex: 3, isHeader: true),
                  _TableText('Tanggal Daftar', flex: 2, isHeader: true),
                  _TableText('Status', flex: 2, isHeader: true),
                  _TableText('Jumlah Review', flex: 2, isHeader: true),
                  _TableText('Aksi', flex: 3, isHeader: true),
                ],
              ),
            ),
            if (users.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                child: Text(
                  'Tidak ada pengguna yang sesuai.',
                  style: AppTextStyles.bodySecondary,
                ),
              )
            else
              ...users.map((user) => _UserRow(user: user, status: user.status)),
          ],
        ),
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  final AdminUserModel user;
  final String status;

  const _UserRow({required this.user, required this.status});

  bool get _isSuspended => status == 'Suspended';

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
          _TableText(user.name, flex: 2),
          _TableText(user.email, flex: 3),
          _TableText(_formatDate(user.createdAt), flex: 2),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: _StatusBadge(status: status),
            ),
          ),
          _TableText('${user.reviewCount}', flex: 2),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isSuspended)
                  _ActionButton(
                    label: 'Reaktivasi',
                    icon: Icons.check_circle_outline,
                    backgroundColor: AppColors.success,
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => const _ConfirmUserStatusDialog(
                          title: 'Reaktivasi Pengguna',
                          description:
                              'Pengguna akan kembali dapat menggunakan aplikasi.',
                        ),
                      );

                      if (confirmed == true) {
                        await context.read<UserProvider>().reactivateUser(
                          user.id,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Pengguna berhasil diaktifkan kembali.',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  )
                else
                  _ActionButton(
                    label: 'Suspend',
                    icon: Icons.block,
                    backgroundColor: AppColors.primary,
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => const _ConfirmUserStatusDialog(
                          title: 'Suspend Pengguna',
                          description:
                              'Pengguna tidak akan dapat menggunakan fitur aplikasi sampai diaktifkan kembali.',
                        ),
                      );

                      if (confirmed == true) {
                        await context.read<UserProvider>().suspendUser(user.id);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pengguna berhasil disuspend.'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                const SizedBox(width: AppSizes.spaceS),
                IconButton(
                  tooltip: 'Hapus akun',
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => _DeleteUserDialog(user: user),
                    );

                    if (confirmed == true) {
                      await context.read<UserProvider>().deleteUser(user.id);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Data user berhasil dihapus dari Firestore.',
                            ),
                          ),
                        );
                      }
                    }
                  },
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

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: AppSizes.iconS),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
          textStyle: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          ),
        ),
      ),
    );
  }
}

class _TableText extends StatelessWidget {
  final String text;
  final int flex;
  final bool isHeader;

  const _TableText(this.text, {required this.flex, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSizes.paddingM),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isHeader
              ? AppTextStyles.smallBold.copyWith(color: AppColors.textSecondary)
              : AppTextStyles.body,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  bool get _isActive => status == 'Aktif';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: _isActive
            ? AppColors.success.withOpacity(0.15)
            : AppColors.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: _isActive ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _formatDate(dynamic value) {
  if (value == null) return '-';

  if (value is Timestamp) {
    return DateFormat('yyyy-MM-dd').format(value.toDate());
  }

  if (value is DateTime) {
    return DateFormat('yyyy-MM-dd').format(value);
  }

  final text = value.toString().trim();
  return text.isEmpty ? '-' : text;
}

class _ConfirmUserStatusDialog extends StatelessWidget {
  final String title;
  final String description;

  const _ConfirmUserStatusDialog({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Lanjutkan'),
        ),
      ],
    );
  }
}

class _DeleteUserDialog extends StatelessWidget {
  final AdminUserModel user;

  const _DeleteUserDialog({required this.user});

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
                  Text('Hapus Data User', style: AppTextStyles.h2),
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
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: AppColors.error.withOpacity(0.35)),
                ),
                child: Text(
                  'Tindakan Permanen\n\n'
                  'Penghapusan data user akan menghapus:\n'
                  '• Dokumen user dari Firestore\n'
                  '• Data profil yang tersimpan di collection users\n'
                  '• User tidak akan muncul lagi di Manajemen Pengguna\n\n'
                  'Catatan: akun Firebase Authentication belum terhapus.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.error,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text(
                'Apakah Anda yakin ingin menghapus data user ini?',
                style: AppTextStyles.smallBold,
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                '${user.name} (${user.email})',
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
                  '⚠ Tindakan ini tidak dapat dibatalkan dari dashboard admin.',
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
                    child: const Text('Hapus Data'),
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
