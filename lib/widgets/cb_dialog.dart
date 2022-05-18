import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';

class CBDialog extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget? content;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback? onLeftButtonTap;
  final VoidCallback? onRightButtonTap;
  final bool closeOnChoose;
  final bool gradientPositionAtRight;

  const CBDialog({
    Key? key,
    required this.title,
    this.subTitle,
    this.content,
    this.leftButtonText = 'Cancel',
    this.rightButtonText = 'Confirm',
    this.onLeftButtonTap,
    this.onRightButtonTap,
    this.closeOnChoose = true,
    this.gradientPositionAtRight = true,
  }) : super(key: key);

  BoxDecoration gradientDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.orange.withOpacity(0.8),
      );

  BoxDecoration outlinedDecoration(bool dark) => BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: HexColor('FFFFFF').withOpacity(0.1),
          width: 1.5,
        ),
      );

  static Color darkColor = HexColor('191919');
  static Color lightColor = HexColor('FFFFFF');

  Widget _button(
    BuildContext context,
    String text,
    bool gradient,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: EdgeInsets.only(top: PSizeConfig.height(16)),
        width: PSizeConfig.width(130),
        height: PSizeConfig.height(gradient ? 39 : 40),
        decoration: gradient
            ? gradientDecoration()
            : outlinedDecoration(_isDark(context)),
        child: Center(
          child: Text(
            text,
            style: buttonTextStyle(context, gradient),
          ),
        ),
      ),
    );
  }

  TextStyle titleStyle(BuildContext context) => GoogleFonts.workSans(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: _isDark(context) ? HexColor('FFFFFF') : HexColor('2C2929'),
      );

  TextStyle subTitleStyle(BuildContext context) => GoogleFonts.workSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _isDark(context)
            ? HexColor('FFFFFF').withOpacity(0.87)
            : HexColor('979797'),
      );

  TextStyle buttonTextStyle(BuildContext context, bool gradient) =>
      GoogleFonts.workSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: gradient
            ? HexColor('FFFFFF')
            : (_isDark(context)
                ? HexColor('FFFFFF').withOpacity(0.6)
                : HexColor('C1C1C1')),
      );

  bool _isDark(BuildContext context) =>
      MediaQuery.of(context).platformBrightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PSizeConfig.blockHeight * 100,
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: PSizeConfig.height(146),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: PSizeConfig.width(25)),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isDark(context) ? darkColor : lightColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1599999964237213),
                      offset: Offset(0, 8),
                      blurRadius: 36,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  vertical: PSizeConfig.height(24),
                  horizontal: PSizeConfig.width(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: PSizeConfig.height(10)),
                      child: Text(
                        title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle(context),
                      ),
                    ),
                    _button(
                      context,
                      rightButtonText,
                      gradientPositionAtRight,
                      () {
                        onRightButtonTap?.call();
                        if (closeOnChoose) Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
