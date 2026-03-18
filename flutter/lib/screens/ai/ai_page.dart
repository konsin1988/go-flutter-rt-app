import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:rt_app/widgets/app_top_bar.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'package:rt_app/utils/constants.dart';
import 'package:rt_app/auth/auth_provider.dart';
import 'widgets/AiButton.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {

    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: SW * 0.06, vertical: SH * 0.025),
      child: Column(
      	  children: [ 
	    AiButton(
	      AiLink: AppRoutes.assistant, 
	      AiAvatar: '${AppImageIcons.assistant}', 
	      AiTitle: "Твой Ассистент",
	      ),
	    SizedBox(height: SH * 0.013),
	    AiButton(
	      AiLink: AppRoutes.absence, 
	      AiAvatar: '${AppImageIcons.absenceAvatar}',
	      AiTitle: "Отпускатор",
	    ),
      	  ],
      	),
    );
  }
}

