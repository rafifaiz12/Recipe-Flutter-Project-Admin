import 'package:flutter/material.dart';
import 'package:siresep_admin/core/widgets/admin_page_wrapper.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminPageWrapper(
      title: 'Moderasi Review',
      subtitle: 'Kelola ulasan pengguna',
    );
  }
}
