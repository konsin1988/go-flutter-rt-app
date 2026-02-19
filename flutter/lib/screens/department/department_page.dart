import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'package:rt_app/features/department/data/dept_queries.dart';
import 'package:rt_app/features/department/data/dept_models.dart';
import 'package:rt_app/features/department/data/dept_repository.dart';
import 'package:rt_app/graphql/graphql_service.dart';
import 'widgets/DepartmentField.dart';
import 'widgets/UserField.dart';
import 'widgets/DeptUserTile.dart';
import 'widgets/GDField.dart';

class DepartmentPage extends StatelessWidget {
  final int departmentId;

  const DepartmentPage({
    required this.departmentId,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;
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

	final department = Department(
	  id: dept.id,
	  name: dept.name.toString(),
	  parent: dept.parent,
	  head: dept.head,
	);


	return Container(
	  width: double.infinity,
	  height: double.infinity,
	  child: Column( 
	    children: [
	      Padding(
	        padding: EdgeInsets.symmetric(horizontal: SW * 0.08, vertical: SH * 0.015),
	        child: Center(
		  child: Text(
		    dept.name,
		    style: RTFontStyle.h2.value.copyWith(fontSize: 20), 
		  ),
		),
	      ),
	      dept.id == 108  
		?  Padding(
		    padding: EdgeInsets.only(top: SH * 0.01), 
		    child: GDField(),
		    )
		: UserField(user_id: dept.head ?? 0, name: dept.head_fio ?? ''),
	      dept.parent != null 
		    ? DepartmentField(id: dept.parent!, deptName: dept.parent_name!) 
		    : Text(''), 
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


