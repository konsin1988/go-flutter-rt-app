import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/user/state/user_provider.dart';
import '../../widgets/app_top_bar.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    if (userProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = userProvider.user;

    if (user == null) {
      return const Center(child: Text('No user data'));
    }
    return Center(
	child: Column(
	  children: [
	    const Spacer(flex: 2),
	    Text('Профиль', style: TextStyle(fontSize: 24)),
	    Text('Login: ${user.login}'),
	    Text('Email: ${user.email}'),
	    const Spacer(flex: 2),
	  ],
	),
    );
  }
}

