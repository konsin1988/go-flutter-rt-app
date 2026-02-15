import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';
import '../utils/constants.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppTopBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;

    return AppBar(
      centerTitle: true,
      backgroundColor: RTColorStyle.dark1000.value,
      title: Text(
	title,
	style: RTFontStyle.appTitle.value 
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
