import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rt_app/features/user/data/user_models.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'phone_field.dart';
import 'email_field.dart';

import 'package:rt_app/screens/widgets/title_field.dart';
import 'package:rt_app/screens/widgets/value_field.dart';

class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo({
    super.key, 
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    
    return Column(
      children: [
        const Spacer(flex:1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    	const Spacer(flex:1),
	InkWell(
	  onTap: () {
	    context.push('/image', extra: user.photoURL);
	  },
	  child: Container(
    	    width: sw * 0.4,
    	    height: sw * 0.4,
    	    padding: const EdgeInsets.all(4),
    	    decoration: BoxDecoration(
    	      shape: BoxShape.circle, 
    	      border: Border.all(
    	        color: RTColorStyle.beige900.value,
    	        width: 2,
    	      ),
    	    ),
    	    child: CircleAvatar(
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: user.photoURL == null
                    ? const Icon(Icons.person)
                    : null,
    	    ),
    	  ),
	),
    	const Spacer(flex:1),
    
    	Column(
    	  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
    	    SizedBox(height: sh * 0.02),
    	    Text(user.lastName),
    	    Row(
    	      children: [
    		SizedBox(width:15),
    	        Text(user.firstName),
    	           ],
    	    ),
    	    Row(
    	      children: [
    		SizedBox(width:5),
    		Text(user.secondName),
    	      ],
    	    ),
    	    SizedBox(height:20),
    	    Row(
    	      children: [
    	        Icon(Icons.cake, size: 25, color: RTColorStyle.beige600.value),
    	        SizedBox(width:10),
                	Text(
    		  user.birthday ?? '',
    		  style: RTFontStyle.appTitle.value.copyWith(fontSize: sw * 0.05),
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
          padding: EdgeInsets.only(left: 16, bottom: sh * 0.01),
          child: Text(
    	"Основная информация",
    	style: RTFontStyle.appTitle.value 
          ),
        ),
    
        /// -------- Section 2 --------
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              TitleField(title: 'Департамент'),
	            ...List.generate(
	                user.deptList.length,
	                (index) {
	                  final dept = user.deptList[index];
	                  return ValueField(id: dept.id, title: dept.name, link: '/profile/department');
              }),

              TitleField(title: 'Должность'),
              ValueField(title: user.position!),

              user.inner != null 
              ? Column(
                  children: [
                    TitleField(title: 'Рабочий телефон'),
                    ValueField(title: user.inner!),
              ])
              : const SizedBox.shrink(),

              user.mobile != null && user.mobile != ''
                ? PhoneField(field: 'Мобильный телефон:', value: user.mobile != null ? '${user.mobile}' : '')
                : const SizedBox.shrink(),
              EmailField(field: 'Электронная почта:', value: user.email),
            ],
          ),
        ),
        const Spacer(flex:4),
      ],
    );
  }
}
