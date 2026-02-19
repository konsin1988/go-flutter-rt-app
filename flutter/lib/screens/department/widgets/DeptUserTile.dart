import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rt_app/utils/constants.dart';
import 'package:rt_app/features/department/data/dept_models.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';


class DeptUserTile extends StatelessWidget {
  final DeptUser user;

  const DeptUserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory, 
      onTap: () {
	context.push('/profile/user/${user.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? const Icon(Icons.person)
                  : null,
            ),

            const SizedBox(width: 16),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fio,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  if (user.position != null)
                    Text(
                      user.position!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

