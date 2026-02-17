import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rt_app/features/user/data/user_models.dart';
import 'package:rt_app/features/user/state/user_provider.dart';
import 'widgets/UserInfo.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    if (userProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final user = userProvider.authUser;
    if (user == null) {
      return const CircularProgressIndicator();
    }
    return Center(
      child: UserInfo(user: user),
    );
  }
}

