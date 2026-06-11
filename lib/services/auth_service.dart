import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User> loginAdmin({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Login gagal. User tidak ditemukan.');
    }

    final adminDoc = await _firestore.collection('admins').doc(user.uid).get();

    if (!adminDoc.exists) {
      await _auth.signOut();
      throw Exception('Akun ini tidak terdaftar sebagai admin.');
    }

    final data = adminDoc.data();

    if (data == null || data['role']?.toString().toLowerCase() != 'admin') {
      await _auth.signOut();
      throw Exception('Akun ini tidak memiliki role admin.');
    }

    return user;
  }

  Future<bool> isCurrentUserAdmin() async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    final adminDoc = await _firestore.collection('admins').doc(user.uid).get();

    if (!adminDoc.exists) {
      return false;
    }

    final data = adminDoc.data();

    return data?['role']?.toString().toLowerCase() == 'admin';
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
