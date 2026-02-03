import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/app_top_bar.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';
import '../../utils/constants.dart';
import '../../auth/auth_provider.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});


  @override
  Widget build(BuildContext context) {
    Future<void> _onAssistantPressed() async {
      try {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth.logout();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed')),
        );
      } 
    }

    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: SW * 0.06, vertical: SH * 0.025),
      child: Column(
      	  children: [ 
	    ElevatedButton(
	      onPressed: () {context.push(AppRoutes.assistant);},
	      style: ElevatedButton.styleFrom(
	        backgroundColor: RTColorStyle.dark800.value,
	        foregroundColor: RTColorStyle.light700.value,
	        padding: EdgeInsets.symmetric(horizontal: SW * 0.05, vertical: SH * 0.008),
	        shape: RoundedRectangleBorder(
	          borderRadius: BorderRadius.circular(8),
	        ),
	      ),
	      child: Row(
		children: [
		  Container(
		    width: SW * 0.14,
		    height: SW * 0.14,
		    padding: const EdgeInsets.all(2),
		    decoration: BoxDecoration(
  		      shape: BoxShape.circle, 
  		      border: Border.all(
  		        color: RTColorStyle.beige900.value,
  		        width: 1,
  		      ),
  		    ),
		    child: CircleAvatar(
                      backgroundImage: AssetImage(
		        '${AppImageIcons.assistant}',
                      ),
		    ),
		  ),
		  Spacer(flex: 2),
		  Center(
		    child: Text(
		      'Твой ассистент', 
		      style: RTFontStyle.ProfileField.value.copyWith(fontSize: SW * 0.05),
		    ),
		  ),
		  Spacer(flex: 2),
		],
	      ),
	    ),
      	  ],
      	),
    );
  }
}

