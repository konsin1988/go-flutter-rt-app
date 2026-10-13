import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rt_app/features/user/data/user_models.dart';

class SearchUsersList extends StatelessWidget {
  const SearchUsersList({
    required this.users,
    super.key,
  });

  final List<SearchUser> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('Пользователи не найдены'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final photoUrl = user.photoURL;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
            child: photoUrl == null || photoUrl.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user.fio),
          onTap: () {
            context.push('/profile/user/${user.id}');
          },
        );
      },
    );
  }
}
