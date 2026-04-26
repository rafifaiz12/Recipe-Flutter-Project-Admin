import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/pages/users/widgets/delete_user_dialog.dart';
import 'package:siresep_admin/pages/users/widgets/suspend_user_dialog.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String _selectedStatus = 'all statuses';

  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Ahmad Fauzi',
      'email': 'ahmad.fauzi@example.com',
      'registeredAt': '2026-01-15',
      'status': 'Active',
      'reviewCount': 12,
    },
    {
      'name': 'Siti Nurhaliza',
      'email': 'siti.nur@example.com',
      'registeredAt': '2026-02-20',
      'status': 'Active',
      'reviewCount': 8,
    },
    {
      'name': 'Budi Santoso',
      'email': 'budi.santoso@example.com',
      'registeredAt': '2026-03-10',
      'status': 'Suspended',
      'reviewCount': 3,
    },
    {
      'name': 'Dewi Lestari',
      'email': 'dewi.lestari@example.com',
      'registeredAt': '2026-03-25',
      'status': 'Active',
      'reviewCount': 15,
    },
    {
      'name': 'Eko Prasetyo',
      'email': 'eko.prasetyo@example.com',
      'registeredAt': '2026-04-01',
      'status': 'Active',
      'reviewCount': 5,
    },
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((user) {
      final query = _query.toLowerCase();
      final name = (user['name'] as String).toLowerCase();
      final email = (user['email'] as String).toLowerCase();
      final status = user['status'] as String;

      final matchesQuery =
          query.isEmpty || name.contains(query) || email.contains(query);

      final matchesStatus =
          _selectedStatus == 'All statuses' || status == _selectedStatus;

      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _suspendUser(Map<String, dynamic> user) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => SuspendUserDialog(user: user),
    );

    if (result != true) return;

    setState(() {
      user['status'] = 'Suspended';
    });
  }

  void _reactivateUser(Map<String, dynamic> user) {
    setState(() {
      user['status'] = 'Active';
    });
  }

  Future<void> _deleteUser(Map<String, dynamic> user) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteUserDialog(user: user),
    );

    if (result != true) return;

    setState(() {
      _users.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Management', style: AppTextStyles.h1),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              'Manage application user accounts',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: AppSizes.spaceXL),
            _buildFilters(),
            const SizedBox(height: AppSizes.spaceXL),
            _UsersTable(
              users: users,
              onSuspendTap: _suspendUser,
              onReactivateTap: _reactivateUser,
              onDeleteTap: _deleteUser,
            ),
            const SizedBox(height: AppSizes.spaceL),
            _buildFooter(users.length),
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
              hintText: 'Search by name or email...',
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
                value: 'All Status',
                child: Text('All Status'),
              ),
              DropdownMenuItem(value: 'Active', child: Text('Active')),
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

  Widget _buildFooter(int filteredCount) {
    return Row(
      children: [
        Text(
          'Showing $filteredCount from ${_users.length} users',
          style: AppTextStyles.bodySecondary,
        ),
        const Spacer(),
        OutlinedButton(onPressed: () {}, child: const Text('Previously')),
        const SizedBox(width: AppSizes.spaceS),
        ElevatedButton(onPressed: () {}, child: const Text('1')),
        const SizedBox(width: AppSizes.spaceS),
        OutlinedButton(onPressed: () {}, child: const Text('2')),
        const SizedBox(width: AppSizes.spaceS),
        OutlinedButton(onPressed: () {}, child: const Text('Next')),
      ],
    );
  }
}

class _UsersTable extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final ValueChanged<Map<String, dynamic>> onSuspendTap;
  final ValueChanged<Map<String, dynamic>> onReactivateTap;
  final ValueChanged<Map<String, dynamic>> onDeleteTap;

  const _UsersTable({
    required this.users,
    required this.onSuspendTap,
    required this.onReactivateTap,
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
            Container(
              color: AppColors.inputBg,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingM,
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TableText('Name', flex: 2, isHeader: true),
                  _TableText('Email', flex: 3, isHeader: true),
                  _TableText('Registration Date', flex: 2, isHeader: true),
                  _TableText('Status', flex: 2, isHeader: true),
                  _TableText('Number of Reviews', flex: 2, isHeader: true),
                  _TableText('Action', flex: 3, isHeader: true),
                ],
              ),
            ),
            if (users.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                child: Text(
                  'There are no suitable users.',
                  style: AppTextStyles.bodySecondary,
                ),
              )
            else
              ...users.map(
                (user) => _UserRow(
                  user: user,
                  onSuspendTap: () => onSuspendTap(user),
                  onReactivateTap: () => onReactivateTap(user),
                  onDeleteTap: () => onDeleteTap(user),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onSuspendTap;
  final VoidCallback onReactivateTap;
  final VoidCallback onDeleteTap;

  const _UserRow({
    required this.user,
    required this.onSuspendTap,
    required this.onReactivateTap,
    required this.onDeleteTap,
  });

  bool get _isSuspended => user['status'] == 'Suspended';

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
          _TableText(user['name'] as String, flex: 2),
          _TableText(user['email'] as String, flex: 3),
          _TableText(user['registeredAt'] as String, flex: 2),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: _StatusBadge(status: user['status'] as String),
            ),
          ),
          _TableText('${user['reviewCount']}', flex: 2),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isSuspended)
                  _ActionButton(
                    label: 'Reactivation',
                    icon: Icons.check_circle_outline,
                    backgroundColor: AppColors.success,
                    onTap: onReactivateTap,
                  )
                else
                  _ActionButton(
                    label: 'Suspend',
                    icon: Icons.block,
                    backgroundColor: AppColors.primary,
                    onTap: onSuspendTap,
                  ),
                const SizedBox(width: AppSizes.spaceS),
                IconButton(
                  tooltip: 'Delete account',
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

  bool get _isActive => status == 'Active';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: _isActive
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.12),
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
