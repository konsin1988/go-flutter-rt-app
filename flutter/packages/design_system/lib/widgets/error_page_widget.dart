import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:design_system/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

typedef RefreshCallback = Future<void> Function();

class DSErrorPageWidget extends StatefulWidget {
  final String? title;
  final String error;
  final RefreshCallback? onRefresh;

  const DSErrorPageWidget(
      {super.key, required this.error, this.title, this.onRefresh});

  @override
  State<DSErrorPageWidget> createState() => _DSErrorPageWidgetState();
}

class _DSErrorPageWidgetState extends State<DSErrorPageWidget> {
  bool isPressedFull = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverFillRemaining(
        hasScrollBody: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SvgPicture.asset("assets/images/error_placeholder.svg"),
              ),
              Text(
                widget.title == null ? "Ошибка загрузки данных" : widget.title!,
                style: DSFontStyle.h3.value
                    .copyWith(color: DSColorStyle.light1000.value),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isPressedFull
                        ? GestureDetector(
                            onLongPress: () async {
                              await Clipboard.setData(
                                      ClipboardData(text: widget.error))
                                  .then((_) {
                                if (context.mounted) {
                                  HapticFeedback.lightImpact();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      dsSnackBar(
                                          duration: Duration(seconds: 2),
                                          backgroundColor:
                                              DSColorStyle.systemSuccess.value,
                                          content: Text(
                                            "Текст ошибки скопирован",
                                            style: DSFontStyle.bodyM.value
                                                .copyWith(
                                                    color: DSColorStyle
                                                        .light1000.value),
                                          )));
                                }
                              });
                            },
                            child: Text(
                              widget.error,
                              style: DSFontStyle.bodyL.value
                                  .copyWith(color: DSColorStyle.light700.value),
                            ),
                          )
                        : TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              overlayColor: Colors.transparent,
                            ),
                            onPressed: () {
                              setState(() {
                                isPressedFull = !isPressedFull;
                              });
                            },
                            child: Text("Подробнее...",
                                style: DSFontStyle.h5.value.copyWith(
                                    color: DSColorStyle.light700.value)))),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
