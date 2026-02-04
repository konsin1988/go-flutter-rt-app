import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';
import '../utils/constants.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? leadingImage;

  const AppTopBar({
    super.key,
    required this.title,
    this.leadingImage,
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
      leading: leadingImage != null
	? InkWell(
	    onTap: () {
	      context.go(AppRoutes.profile);
	    },
	    child: Center( 
	      child: Container(
	          width: SW * 0.08,
	          height: SW * 0.08,
	          padding: const EdgeInsets.all(1),
	          decoration: BoxDecoration(
  	            shape: BoxShape.circle, 
  	            border: Border.all(
  	              color: RTColorStyle.beige900.value,
  	              width: 0.5,
  	            ),
  	          ),
	          child: CircleAvatar(
	    	backgroundImage: NetworkImage(
	    	  leadingImage!,
		  ),
	        ),
	      ),
	    ),
	  )
	: null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
