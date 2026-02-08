import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/user/state/user_provider.dart';

import '../utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/app_top_bar.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';

class BottomNavScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavScaffold ({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  String appBarTitle(String location) {
    final routeTitle = AppBarTitles.routeTitles[location];
    if (routeTitle != null) {
      return routeTitle;
    }
    return AppBarTitles.tabTitles[navigationShell.currentIndex];
  }
  
  String? appBarImage(BuildContext context, String location) {
    if (location.startsWith('/profile')) return null;
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    return user?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: DefaultTextStyle(
        style: RTFontStyle.h2.value, 
        child: navigationShell,
      ),
      appBar: AppTopBar(
	title: appBarTitle(location),
	leadingImage: appBarImage(context, location),
      ),
      backgroundColor: RTColorStyle.dark900.value,
      bottomNavigationBar: BottomNavigationBar(
	currentIndex: navigationShell.currentIndex,
      	type: BottomNavigationBarType.fixed,
      	onTap: _onTap,
      	backgroundColor: RTColorStyle.dark1000.value,
      	selectedLabelStyle: tabbarStyle,
      	selectedItemColor: RTColorStyle.beige1000.value,
      	unselectedItemColor: RTColorStyle.light800.value,
      	unselectedLabelStyle: tabbarStyle,
      	iconSize: 22,
      	items: [
      	  BottomNavigationBarItem(
      	    icon: SvgPicture.asset(AppIcons.home, width: 24, height: 24),
      	    activeIcon: SvgPicture.asset(AppIcons.home, colorFilter: ColorFilter.mode(RTColorStyle.beige900.value, BlendMode.srcIn)),
      	    label: 'Главная',
      	  ),
      	  BottomNavigationBarItem(
      	    icon: SvgPicture.asset(AppIcons.ai, width: 24, height: 24),
      	    activeIcon: SvgPicture.asset(AppIcons.ai, colorFilter: ColorFilter.mode(RTColorStyle.beige900.value, BlendMode.srcIn)),
      	    label: 'ИИ',
      	  ),
      	  BottomNavigationBarItem(
      	    icon: SvgPicture.asset(AppIcons.services, width: 24, height: 24),
      	    activeIcon: SvgPicture.asset(AppIcons.services, colorFilter: ColorFilter.mode(RTColorStyle.beige900.value, BlendMode.srcIn)),
      	    label: 'Сервисы',
      	  ),
      	  BottomNavigationBarItem(
      	    icon: SvgPicture.asset(AppIcons.profile, width: 24, height: 24),
      	    activeIcon: SvgPicture.asset(AppIcons.profile, colorFilter: ColorFilter.mode(RTColorStyle.beige900.value, BlendMode.srcIn)),
      	    label: 'Профиль',
	  ),
	],
      ), 
    );
  }
}


