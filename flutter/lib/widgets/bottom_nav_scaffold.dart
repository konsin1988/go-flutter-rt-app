import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/user/state/user_provider.dart';

import '../utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/app_top_bar.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';
import 'BottomNavigationBarItem.dart';
import 'AiDrawer.dart';

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
    if (location.contains('department')) {
      return "Департамент";
    }
    return AppBarTitles.tabTitles[navigationShell.currentIndex];
    return 'aa';
  }

  
  
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.authUser;
    final imageSize = SW * 0.07;
    final imageActiveSize = SW * 0.068;

    return Scaffold(
      body: DefaultTextStyle(
        style: RTFontStyle.h2.value, 
        child: navigationShell,
      ),
      appBar: AppTopBar(
	title: appBarTitle(location),
      ),
      drawer: AiDrawer(),
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
	  buildNavItem(
	      assetPath: AppIcons.home,
  	      label: 'Главная',
  	      imageSize: imageSize,
  	      imageActiveSize: imageActiveSize,
	  ),
	  buildNavItem(
	      assetPath: AppIcons.ai,
  	      label: 'ИИ',
  	      imageSize: imageSize,
  	      imageActiveSize: imageActiveSize,
	  ),
	  buildNavItem(
	      assetPath: AppIcons.services,
  	      label: 'Сервисы',
  	      imageSize: imageSize,
  	      imageActiveSize: imageActiveSize,
	  ),
      	  BottomNavigationBarItem(
	    icon: Container(
		  width: SW * 0.075,
		  height: SW * 0.075,
		  padding: const EdgeInsets.all(1),
		  decoration: BoxDecoration(
  		    shape: BoxShape.circle, 
  		    border: Border.all(
  		      color: RTColorStyle.dark800.value,
  		      width: 1,
  		    ),
  		  ),
		  child: CircleAvatar(
                    backgroundImage: NetworkImage(
		      '${user?.photoURL}',
                    ),
		  ),
		),
	    activeIcon: Container(
		  width: SW * 0.075,
		  height: SW * 0.075,
		  padding: const EdgeInsets.all(1),
		  decoration: BoxDecoration(
  		    shape: BoxShape.circle, 
  		    border: Border.all(
  		      color: RTColorStyle.beige900.value,
  		      width: 1
  		    ),
  		  ),
		  child: CircleAvatar(
                    backgroundImage: NetworkImage(
		      '${user?.photoURL}',
                    ),
		  ),
		),
      	    label: 'Профиль',
	  ),
	],
      ), 
    );
  }
}


