import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rt_app/graphql/graphql_service.dart';

import 'package:rt_app/utils/constants.dart';
import 'package:rt_app/features/department/data/dept_models.dart';
import 'package:rt_app/features/user/data/user_repository.dart';
import 'package:rt_app/features/user/data/user_models.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';

class GDField extends StatelessWidget {
  const GDField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;
    final repo = UserRepository(GraphQLService().client);
    
    return FutureBuilder<User>(
      future: repo.userById(28),
      builder: (context, snapshot) {
	if (snapshot.connectionState == ConnectionState.waiting) {
	  return const Center(child: CircularProgressIndicator());
	}

	if (snapshot.hasError) {
	  return Center(child: Text(snapshot.error.toString()));
	}
	if (!snapshot.hasData) {
	  return const Center(child: Text('User not found'));
	}

	final user = snapshot.data!;

    
	return Row(
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
    	      backgroundImage: user.photoURL != null
    	          ? NetworkImage(user.photoURL!)
    	          : null,
    	      child: user.photoURL == null
    	          ? const Icon(Icons.person)
    	          : null,
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
    	    	  user.birthday != null ? '${user.birthday}' : '',
    	    	  style: RTFontStyle.appTitle.value.copyWith(fontSize: SW * 0.05),
    	    	),
    	          ],
    	        ),
    	      ],
    	    ),
    	    const Spacer(flex:1),
    	  ],
    	);
      }
    );
  }
}

