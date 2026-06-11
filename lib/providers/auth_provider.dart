import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:siresep_admin/services/auth_service.dart';

class AdminAuthProvider extends ChangeNotifier {
  final AdminAuthService _authService;

  AdminAuthProvider({AdminAuthService? authService})
    : _authService = authService ?? AdminAuthService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _adminUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get adminUser => _adminUser;
  bool get isLoggedIn => _adminUser != null;

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = await _authService.loginAdmin(
        email: email,
        password: password,
      );

      _adminUser = user;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (error) {
      _adminUser = null;
      _errorMessage = _cleanErrorMessage(error);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkCurrentAdmin() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final isAdmin = await _authService.isCurrentUserAdmin();

      if (isAdmin) {
        _adminUser = _authService.currentUser;
      } else {
        _adminUser = null;
      }

      notifyListeners();
    } catch (error) {
      _adminUser = null;
      _errorMessage = _cleanErrorMessage(error);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _adminUser = null;
      _errorMessage = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _cleanErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('user-not-found')) {
      return 'Email admin tidak ditemukan.';
    }

    if (message.contains('wrong-password') ||
        message.contains('invalid-credential')) {
      return 'Email atau password salah.';
    }

    if (message.contains('invalid-email')) {
      return 'Format email tidak valid.';
    }

    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return message;
  }
}
