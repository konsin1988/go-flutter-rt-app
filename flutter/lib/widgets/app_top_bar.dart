import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ImageProvider? leadingImage;

  const AppTopBar({
    super.key,
    required this.title,
    this.leadingImage,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: RTColorStyle.dark1000.value,
      title: Text(
	title,
	style: RTFontStyle.appTitle.value 
      ),
      leading: leadingImage != null
	? Padding(
	    padding: const EdgeInsets.only(left: 12),
	    child: CircleAvatar(
	      backgroundImage: leadingImage,
	      radius: 18,
	    ),
	)
	: null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
