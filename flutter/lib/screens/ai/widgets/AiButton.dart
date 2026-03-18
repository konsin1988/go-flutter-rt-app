import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:rt_app/widgets/app_top_bar.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'package:rt_app/utils/constants.dart';
import 'package:rt_app/auth/auth_provider.dart';


class AiButton extends StatelessWidget {
  final String AiLink;
  final String AiAvatar;
  final String AiTitle;

  AiButton({
    super.key,
    required this.AiLink,
    required this.AiAvatar,
    required this.AiTitle,
  });

  @override
  Widget build(BuildContext context) {

    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: () {context.push(AiLink);},
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
                AiAvatar,
              ),
            ),
          ),
          Spacer(flex: 2),
          Center(
            child: Text(
              AiTitle, 
              style: RTFontStyle.ProfileField.value.copyWith(fontSize: SW * 0.05),
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
