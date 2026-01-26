import 'package:flutter/material.dart';
import '../data/post_models.dart';
import '../data/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repo;

  PostProvider(this._repo);

  List<Post> posts = [];
  bool loading = false;
  String? error;

  Future<void> loadPosts() async {
    if (loading) return;
    loading = true;
    error = null;
    notifyListeners();

    try {
      posts = await _repo.getPosts();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

