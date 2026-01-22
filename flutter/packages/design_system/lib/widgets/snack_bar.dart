import 'package:flutter/material.dart';

SnackBar dsSnackBar(
    {required Widget content,
    required Color backgroundColor,
    Duration? duration,
    DismissDirection? dismissDirection}) {
  return SnackBar(
      duration: duration ?? const Duration(milliseconds: 800),
      dismissDirection: dismissDirection,
      padding: const EdgeInsets.all(0),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: DSSnackBarContent(
        backgroundColor: backgroundColor,
        child: content,
      ));
}

class DSSnackBarContent extends StatelessWidget {
  const DSSnackBarContent(
      {super.key, required this.child, required this.backgroundColor});

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(72, 0, 0, 0),
            spreadRadius: 2.0,
            blurRadius: 8.0,
            offset: Offset(2, 4),
          )
        ],
        image: DecorationImage(
          alignment: Alignment.centerRight,
          image: AssetImage(
              "assets/images/LOGO_overlay.png"), // Your background image.
          fit: BoxFit.fitHeight,
          colorFilter: ColorFilter.mode(
            backgroundColor.withValues(
                alpha: 0.5), // The color to blend with the image.
            BlendMode.softLight, // The blend mode you choose.
          ),
        ),
      ),
      child: child,
    );
  }
}
