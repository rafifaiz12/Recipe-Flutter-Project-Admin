import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siresep_admin/models/user_model.dart';

class UserService {
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<List<AdminUserModel>> watchUsers() {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AdminUserModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> updateUserStatus({
    required String userId,
    required String status,
  }) async {
    await _usersCollection.doc(userId).update({'status': status});
  }

  Future<void> deleteUser(String userId) async {
    await _usersCollection.doc(userId).delete();
  }
}
