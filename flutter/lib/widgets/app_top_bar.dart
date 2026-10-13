import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_app/features/user/state/user_provider.dart';

import 'package:rt_app/auth/auth_provider.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';

import './search_text_field.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppTopBar({
    super.key,
    this.onSearchChanged,
    this.isProfile = false,
    this.searchMode = false,
    required this.title,
  });

  final bool searchMode;
  final bool isProfile;
  final ValueChanged<String>? onSearchChanged;

  @override
  Widget build(BuildContext context) {

    Future<void> onLogoutPressed() async {
      try {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth.logout();

      } catch (e) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed')),
        );
      } 
    }

    Future<void>searchPressed()async{
      context.read<UserProvider>().setSearchPath('');
      context.push('/profile/search-users');
    }

    //List<String> assistantTitles = ['Ваш ассистент', 'Главная', 'Профиль'];
    return AppBar(
      centerTitle: true,
      backgroundColor: searchMode
      ? RTColorStyle.dark1000.value.withValues(alpha: 0.3)
      : RTColorStyle.dark1000.value,
      iconTheme: IconThemeData(
        color: RTColorStyle.beige1000.value,
      ),
      leading: title == 'Ваш ассистент' 
	      ? null
	      : IconButton(
	          icon: const Icon(Icons.arrow_back),
      	    color: RTColorStyle.beige1000.value,
      	    onPressed: () {
      	      if (context.canPop()) {
      	        context.pop();
      	      }
      	    },
      	  ),

      title: searchMode
      ? SearchTextField()
      : Text(
	        title,
	        style: RTFontStyle.appTitle.value 
        ),

      actions: [
        if (isProfile)
          IconButton(
            icon: Icon(
              Icons.search,
              color: RTColorStyle.beige1000.value,
            ),
            tooltip: 'Search users',
            onPressed: searchPressed
          ),
	      Padding(
	        padding: EdgeInsets.only(right: 12),
	        child: IconButton(
    	      icon: Icon(
	          Icons.logout,
	          color: RTColorStyle.beige1000.value,
	        ),
    	    onPressed: onLogoutPressed 
    	    ),
	      ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
