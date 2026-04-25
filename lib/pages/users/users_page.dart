import 'package:flutter/material.dart';
import 'package:siresep_admin/core/widgets/admin_page_wrapper.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminPageWrapper(
      title: 'Manajemen Pengguna',
      subtitle: 'Pantau dan kelola pengguna aplikasi',
    );
  }
}
