import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../style/colors.dart';
import '../../style/fonts.dart';
import 'widgets/post.dart';
import '../../features/posts/data/post_models.dart';
import '../../features/posts/state/post_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    if (postProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
     
    final posts = postProvider.posts;
    if (posts.isEmpty) {
      return const Center(child: Text('No posts yet'));
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[posts.length - index - 1]);
      },
    );
    //return Center(
    //    child: Text('Главная страница', style: TextStyle(fontSize: 24)),
    //);
  }
}

