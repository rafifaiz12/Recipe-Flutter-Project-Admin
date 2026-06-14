import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:siresep_admin/models/user_model.dart';
import 'package:siresep_admin/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService;

  UserProvider({UserService? userService})
    : _userService = userService ?? UserService();

  StreamSubscription<List<AdminUserModel>>? _subscription;

  List<AdminUserModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AdminUserModel> get users => List.unmodifiable(_users);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenUsers() {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _userService.watchUsers().listen(
      (users) {
        _users = users;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  List<AdminUserModel> filterUsers({
    required String query,
    required String selectedStatus,
  }) {
    final lowerQuery = query.trim().toLowerCase();

    return _users.where((user) {
      final matchesQuery =
          lowerQuery.isEmpty ||
          user.name.toLowerCase().contains(lowerQuery) ||
          user.email.toLowerCase().contains(lowerQuery);

      final matchesStatus =
          selectedStatus == 'Semua Status' || user.status == selectedStatus;

      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> suspendUser(String userId) async {
    await _userService.updateUserStatus(userId: userId, status: 'Suspended');
  }

  Future<void> reactivateUser(String userId) async {
    await _userService.updateUserStatus(userId: userId, status: 'Aktif');
  }

  Future<void> deleteUser(String userId) async {
    await _userService.deleteUser(userId);
  }
}
