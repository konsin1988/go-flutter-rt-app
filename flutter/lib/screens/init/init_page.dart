import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../utils/constants.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';
import '../home/home_page.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _animation = Tween<double>(begin: 0.5, end: 1.6).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.easeOut, 
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
	Future.delayed(const Duration(milliseconds: 200), () {
	  context.go(AppRoutes.home);
	});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  void _goToHomePage() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = Tween(begin: 0.0, end: 1.0).animate(animation);
          final slide = Tween(begin: const Offset(0, 0.1), end: Offset.zero)
              .animate(animation);
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RTColorStyle.dark1000.value,
      body: Center(
        child: ScaleTransition(
	  scale: _animation, 
          child: SvgPicture.asset(
            'assets/images/LOGO.svg',
            height: 50,
          ),
        ),
      ),
    );
  }
}


