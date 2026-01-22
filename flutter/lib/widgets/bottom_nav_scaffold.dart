import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import '../utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
	currentIndex: navigationShell.currentIndex,
      	type: BottomNavigationBarType.fixed,
      	onTap: _onTap,
      	backgroundColor: DSColorStyle.dark1000.value,
      	selectedLabelStyle: tabbarStyle,
      	selectedItemColor: DSColorStyle.beige1000.value,
      	unselectedItemColor: DSColorStyle.light800.value,
      	unselectedLabelStyle: tabbarStyle,
      	iconSize: 22,
      	items: [
      	  BottomNavigationBarItem(
      	    icon: SvgPicture.asset(AppIcons.home, width: 24, height: 24),
      	    activeIcon: SvgPicture.asset(AppIcons.home, colorFilter: ColorFilter.mode(DSColorStyle.beige1000.value, BlendMode.srcIn)),
      	    label: 'Главная',
      	  ),
      	  BottomNavigationBarItem(
      	    icon: SvgPicture.asset(AppIcons.ai, width: 24, height: 24),
      	    activeIcon: SvgPicture.asset(AppIcons.ai, colorFilter: ColorFilter.mode(DSColorStyle.beige1000.value, BlendMode.srcIn)),
      	    label: 'ИИ',
      	  ),
      	  BottomNavigationBarItem(
      	    icon: SvgPicture.asset(AppIcons.services, width: 24, height: 24),
      	    activeIcon: SvgPicture.asset(AppIcons.services, colorFilter: ColorFilter.mode(DSColorStyle.beige1000.value, BlendMode.srcIn)),
      	    label: 'Сервисы',
      	  ),
      	  BottomNavigationBarItem(
      	    icon: SvgPicture.asset(AppIcons.profile, width: 24, height: 24),
      	    activeIcon: SvgPicture.asset(AppIcons.profile, colorFilter: ColorFilter.mode(DSColorStyle.beige1000.value, BlendMode.srcIn)),
      	    label: 'Профиль',
	  ),
	],
      ),
    );
  }
}


