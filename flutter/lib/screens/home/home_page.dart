import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
	child: Text('Главная страница', style: TextStyle(fontSize: 24)),
    );
  }
}

//      appBar: const AppTopBar(
//	title: "Главная",
//      ),
