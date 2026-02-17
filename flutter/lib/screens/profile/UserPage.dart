import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rt_app/graphql/graphql_service.dart';
import 'package:rt_app/features/user/data/user_models.dart';
import 'package:rt_app/features/user/data/user_repository.dart';
import 'widgets/UserInfo.dart';


class UserPage extends StatelessWidget {
  final int userId;
  const UserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final repo = UserRepository(GraphQLService().client);
    
    return FutureBuilder<User>(
      future: repo.userById(userId),
      builder: (context, snapshot) {
	if (snapshot.connectionState == ConnectionState.waiting) {
	  return const Center(child: CircularProgressIndicator());
	}

	if (snapshot.hasError) {
	  return Center(child: Text(snapshot.error.toString()));
	}
	if (!snapshot.hasData) {
	  return const Center(child: Text('User not found'));
	}

	final user = snapshot.data!;

	return Center(
	  child: UserInfo(user: user),
	);
      }
    );
  }
}

class EmptyUserPage extends StatelessWidget {
  const EmptyUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
