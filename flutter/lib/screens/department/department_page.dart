import 'package:flutter/material.dart';

import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';

class DepartmentPage extends StatelessWidget {
  final int departmentId;

  const DepartmentPage({
    required this.departmentId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Center(
	child: Text('Департамент ${departmentId}', style: TextStyle(fontSize: 24)),
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


    //return FutureBuilder<Department>(
    //  future: context.read<DepartmentRepository>().getDepartmentById(departmentId),
    //  builder: (context, snapshot) {
    //    if (snapshot.connectionState == ConnectionState.waiting) {
    //      return const CircularProgressIndicator();
    //    }
    //    if (snapshot.hasError) {
    //      return Text('Error: ${snapshot.error}');
    //    }
    //    final department = snapshot.data!;
    //    return Text('Department: ${department.name}');
    //  },
    //);
