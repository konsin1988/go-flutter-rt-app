import 'package:flutter/material.dart';

import 'package:rt_app/style/fonts.dart';
import 'package:rt_app/features/department/data/dept_models.dart';
import 'package:rt_app/features/department/data/dept_repository.dart';
import 'package:rt_app/graphql/graphql_service.dart';
import 'package:rt_app/screens/widgets/title_field.dart';
import 'package:rt_app/screens/widgets/value_field.dart';

import 'widgets/deptUserTile.dart';

class DepartmentPage extends StatelessWidget {
  final int departmentId;

  const DepartmentPage({
    required this.departmentId,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final repo = DeptRepository(GraphQLService().client);

    return FutureBuilder<DeptById>(
      future: repo.getDeptById(departmentId),
      builder: (context, snapshot) {
	if (snapshot.connectionState == ConnectionState.waiting) {
	  return const Center(child: CircularProgressIndicator());
	}

	if (snapshot.hasError) {
	  return Center(child: Text(snapshot.error.toString()));
	}
	if (!snapshot.hasData) {
	  return const Center(child: Text('Department not found'));
	}

	final dept = snapshot.data!;

	return SizedBox(
	  width: double.infinity,
	  height: double.infinity,
	  child: Column( 
	    children: [
	      Padding(
	        padding: EdgeInsets.symmetric(horizontal: sw * 0.08, vertical: sh * 0.018),
	        child: Center(
		        child: Text(
		          dept.name,
		          style: RTFontStyle.h2.value.copyWith(fontSize: 20), 
		        ),
		      ),
	      ),
	      // dept.id == 108  
		    //?  GDDept()
		    //: UserField(user_id: dept.head ?? 0, name: dept.headFio ?? ''),
        TitleField(title: 'Руководитель'),
        ValueField(id: dept.head!, title: dept.headFio!, link: '/profile/user'),
        SizedBox(height: sh * 0.013),

	      dept.parent != null && dept.parent != 0 
		      ? Column(
              children: [ 
                TitleField(title: 'Вышестоящий департамент'),
                ValueField(id: dept.parent!, title: dept.parentName!, link: '/profile/department')
              ])
          : const SizedBox.shrink(),
        SizedBox(height: sh * 0.013),

        dept.childDeptList.isNotEmpty 
		      ? Column(
            children: [ 
              TitleField(title: 'Дочерние департаменты'),
              for (var dept in dept.childDeptList)
                ValueField(id: dept.id, title: dept.name, link: '/profile/department'),
              SizedBox(height: sh * 0.013),
          ])
          : const SizedBox.shrink(),

	      const Divider(),


	      Expanded(
	        child: ListView.builder(
      	          itemCount: dept.deptUsers.length,
      	          itemBuilder: (context, index) {
		    return DeptUserTile(user: dept.deptUsers[index]);
      	          },
      	        ),
      	      ),
	          ],
	        ),
	      );
      }
    );
  }
}

class EmptyDeptPage extends StatelessWidget {
  const EmptyDeptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}


