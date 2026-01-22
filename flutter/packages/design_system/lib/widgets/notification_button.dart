import 'package:design_system/style/colors.dart';
import 'package:flutter/material.dart';

IconButton dsNotificationButton({required VoidCallback? onPressed}) {
  return IconButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: DSColorStyle.dark900.value,
      elevation: 3,
      shadowColor: DSColorStyle.light500.value.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    onPressed: onPressed,
    icon: Icon(
      color: DSColorStyle.beige1000.value,
      Icons.notifications_outlined,
      size: 22,
    ),
  );
}
