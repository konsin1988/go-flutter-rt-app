import 'package:flutter/material.dart';
import '../data/user_repository.dart';
import '../data/user_models.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repo;
  User? user;
  bool loading = false;

  UserProvider(this._repo){
    print("UserProvider created;");
  }

  Future<void> loadMe() async {
    if (loading || user != null) return;
    loading = true;
    notifyListeners();

    try {
      user = await _repo.getMe();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

