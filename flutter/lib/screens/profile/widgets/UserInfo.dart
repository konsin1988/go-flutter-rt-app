import 'package:flutter/material.dart';

import 'package:rt_app/features/user/data/user_models.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'TextFields.dart';
import 'PhoneField.dart';
import 'DepartmentField.dart';

class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo({
    super.key, 
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;
    
    return Column(
      children: [
        const Spacer(flex:1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    	const Spacer(flex:1),
    	Container(
    	  width: SW * 0.4,
    	  height: SW * 0.4,
    	  padding: const EdgeInsets.all(4),
    	  decoration: BoxDecoration(
    	    shape: BoxShape.circle, 
    	    border: Border.all(
    	      color: RTColorStyle.beige900.value,
    	      width: 2,
    	    ),
    	  ),
    	  child: CircleAvatar(
                backgroundImage: NetworkImage(
    	      '${user.photoURL}',
                ),
    	  ),
    	),
    	const Spacer(flex:1),
    
    	Column(
    	  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
    	    SizedBox(height: SH * 0.02),
    	    Text('${user.lastName}'),
    	    Row(
    	      children: [
    		SizedBox(width:15),
    	        Text('${user.firstName}'),
    	           ],
    	    ),
    	    Row(
    	      children: [
    		SizedBox(width:5),
    		Text('${user.secondName}'),
    	      ],
    	    ),
    	    SizedBox(height:20),
    	    Row(
    	      children: [
    	        Icon(Icons.cake, size: 25, color: RTColorStyle.beige600.value),
    	        SizedBox(width:10),
                	Text(
    		  '${user.birthday}',
    		  style: RTFontStyle.appTitle.value.copyWith(fontSize: SW * 0.05),
    		),
    	      ],
    	    ),
    	  ],
    	),
    	const Spacer(flex:2),
          ],
        ),
    
        const Spacer(flex: 1),
        const Divider(),
        const Spacer(flex: 1),
        
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: SH * 0.01),
          child: Text(
    	"Основная информация",
    	style: RTFontStyle.appTitle.value 
          ),
        ),
    
        /// -------- Section 2 --------
        Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DepartmentField(department: user.deptList[0]),
    	  TextFields(field: 'Должность:', value: '${user.position}'),
              TextFields(field: 'Рабочий телефон:', value: '${user.inner}'),
              PhoneField(field: 'Мобильный телефон:', value: '${user.mobile}'),
              TextFields(field: 'Электронная почта:', value: '${user.email}'),
              //LinkableField(field: 'Руководитель:', value: '${user.headList[0].fio}'),
            ],
          ),
        ),
        const Spacer(flex:4),
      ],
    );
  }
}
