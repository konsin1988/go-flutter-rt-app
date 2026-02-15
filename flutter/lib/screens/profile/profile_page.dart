import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rt_app/auth/auth_provider.dart';
import 'package:rt_app/utils/constants.dart';
import 'package:rt_app/features/user/state/user_provider.dart';
import 'package:rt_app/widgets/app_top_bar.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'widgets/TextFields.dart';
import 'widgets/PhoneField.dart';
import 'widgets/DepartmentField.dart';
import 'helpers/helpers.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _onLogoutPressed() async {
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
    final userProvider = context.watch<UserProvider>();

    if (userProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final user = userProvider.user;

    if (user == null) {
      return const CircularProgressIndicator();
    }

    final userName = extractNameFromEmail(user.email);

    return Center(
	child: Column(
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
	    SizedBox(
	      width: double.infinity,
	      child: ElevatedButton(
	        onPressed: _onLogoutPressed,
	        style: ElevatedButton.styleFrom(
	          backgroundColor: RTColorStyle.dark800.value,
	          foregroundColor: RTColorStyle.light700.value,
	          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
	          shape: RoundedRectangleBorder(
	            borderRadius: BorderRadius.circular(8),
	          ),
	        ),
	        child: Text('Выйти', style: TextStyle(fontSize: 18)),
	      ),
	    ),
	  ],
	),
    );
  }
}

