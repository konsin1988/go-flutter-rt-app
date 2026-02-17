import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rt_app/auth/auth_provider.dart';
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

    Future<void> _onLogoutPressed() async {
      try {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth.logout();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed')),
        );
      } 
    }

    return AppBar(
      centerTitle: true,
      backgroundColor: RTColorStyle.dark1000.value,
      title: Text(
	title,
	style: RTFontStyle.appTitle.value 
      ),
      actions: [
	Padding(
	  padding: EdgeInsets.only(right: 12),
	  child: IconButton(
    	    icon: Icon(
	      Icons.logout,
	      color: RTColorStyle.beige1000.value,
	      ),
    	    onPressed: _onLogoutPressed 
    	  ),
	),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
