import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rt_app/utils/constants.dart';
import 'package:rt_app/features/department/data/dept_models.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';

class DepartmentField extends StatelessWidget {
  final Department department;

  const DepartmentField({
    required this.department,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SW = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
	Padding(
	  padding: EdgeInsets.only(left: SW * 0.06),
	  child: Text(
	    'Вышестоящий департамент',
	    style: RTFontStyle.ProfileField.value 
	  ),
	),
	InkWell(
	  splashFactory: NoSplash.splashFactory, 
	  onTap: () {
	    context.push('/profile/department/${department.id}');
	  },
	  child: Padding(
	    padding: EdgeInsets.only(left: SW * 0.3, 
	          		  right: SW * 0.05, 
	          		  top: SW * 0.005, 
	          		  bottom: SW * 0.025),
	    child: Text(
	      '${department.name}',
	      style: RTFontStyle.ProfileValue.value 
	    ),
	  ),
	),
    ]);
  }
}

