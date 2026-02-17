import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:rt_app/features/user/data/user_repository.dart';
import 'package:rt_app/features/user/data/user_models.dart';


class UserProvider extends ChangeNotifier{
  final UserRepository _repo;

  User? _authUser;
  User? _currentUser;
  bool loading = false;

  User? get authUser => _authUser;
  User? get currentUser => _currentUser;

  UserProvider(this._repo){
    loadMe();
    debugPrint("UserProvider created;");
  }

  Future<void> loadProfile({required int userId}) async {
    loading = true;
    notifyListeners();

    try {
      _currentUser = await _repo.userById(userId);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMe() async {
    if (loading || _authUser != null) return;
    loading = true;
    notifyListeners();

    try {
      _authUser = await _repo.getMe();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

