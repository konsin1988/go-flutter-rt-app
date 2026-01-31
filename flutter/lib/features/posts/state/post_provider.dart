import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../data/post_models.dart';
import '../data/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repo;


  List<Post> posts = [];
  bool loading = false;
  String? error;
  
  PostProvider(this._repo){
    loadPosts();
    debugPrint("PostProvider init. LoadPost method run...");
  }

  Future<void> loadPosts() async {
    if (loading) return;
    loading = true;
    error = null;
    posts = await _repo.getPosts();

    notifyListeners();
    //try {
    //  posts = await _repo.getPosts();
    //  print(posts);
    //} catch (e) {
    //  error = e.toString();
    //} finally {
    loading = false;
    notifyListeners();
    //}
  }
}

