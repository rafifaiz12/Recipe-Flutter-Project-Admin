import 'package:flutter/material.dart';
import 'package:siresep_admin/core/widgets/admin_page_wrapper.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminPageWrapper(
      title: 'Manajemen Resep',
      subtitle: 'Kelola seluruh data resep aplikasi',
    );
  }
}
