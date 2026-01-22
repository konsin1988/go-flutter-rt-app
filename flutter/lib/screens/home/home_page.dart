import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: const AppTopBar(
	title: 
      ),
      body: Center(
	child: Text('Главная страница', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

