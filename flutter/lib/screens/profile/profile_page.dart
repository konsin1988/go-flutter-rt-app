import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
	child: Text('Профиль', style: TextStyle(fontSize: 24)),
    );
  }
}

