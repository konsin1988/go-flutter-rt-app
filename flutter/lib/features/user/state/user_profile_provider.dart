import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:rt_app/features/user/data/user_repository.dart';
import 'package:rt_app/features/user/data/user_models.dart';

class UserProfileProvider extends ChangeNotifier {
  final UserRepository _repo;

  final Map<String, User> _users = {};
  bool loading = false;

  UserProfileProvider(this._repo);

  User? getUser(String id) => _users[id];

  Future<void> loadUser(String id) async {
    if (_users.containsKey(id)) return;

    loading = true;
    notifyListeners();

    try {
      final user = await _repo.getUserById(id);
      _users[id] = user;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

