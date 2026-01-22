import 'package:design_system/style/colors.dart';
import 'package:flutter/material.dart';

class DSLoadingPageWidget extends StatelessWidget {
  const DSLoadingPageWidget({
    super.key = const Key("loading"),
    this.circular = false,
  });

  final bool circular;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: circular
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      DSColorStyle.dark1000.value)))
          : Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: DSColorStyle.beige1000.value,
                  minHeight: 2,
                ),
              ],
            ),
    );
  }
}
