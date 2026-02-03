import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AssistantPage extends StatelessWidget{
  const AssistantPage({super.key});

  @override
  Widget build(BuildContext context) {

    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;

    return Center(
      child: Text("Welcome to assistant page")
    ); 
  }
}
