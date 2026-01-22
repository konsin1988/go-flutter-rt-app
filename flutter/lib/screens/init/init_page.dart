import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});
  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void InitState() {
    super.initState();
    Timer(const Duration(milliseconds: 800), () {
      if (context.mounted) {
	context.goNamed('main');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/LOGO.png',
              width: 120,
              height: 50,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'RT App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              )),
          ],
        ),
      ),
    );
  }
}
