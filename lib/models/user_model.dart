import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String status;
  final int reviewCount;
  final dynamic createdAt;

  const AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.reviewCount,
    this.createdAt,
  });

  factory AdminUserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return AdminUserModel(
      id: doc.id,
      name:
          data['name']?.toString() ??
          data['displayName']?.toString() ??
          'Tanpa Nama',
      email: data['email']?.toString() ?? '-',
      status: _normalizeStatus(data['status']?.toString()),
      reviewCount: int.tryParse(data['reviewCount']?.toString() ?? '0') ?? 0,
      createdAt: data['createdAt'] ?? data['registeredAt'],
    );
  }
}

String _normalizeStatus(String? value) {
  final status = value?.trim().toLowerCase() ?? '';

  if (status == 'suspended') return 'Suspended';
  if (status == 'aktif' || status == 'active') return 'Aktif';

  return 'Aktif';
}
