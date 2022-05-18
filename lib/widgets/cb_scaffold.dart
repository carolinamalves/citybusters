import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';

class CBScaffold extends StatelessWidget {
  final Widget body;
  final bool fullScreen;
  final bool bottom;
  final Color? backgroundColor;
  final Color? statusBarColor;
  final bool resizeToAvoidBottomInset;
  final SystemUiOverlayStyle? style;
  final PreferredSizeWidget? appBar;
  final bool unFocusOnBGTap;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? belowSnackbar;
  final bool extendBodyBehindAppBar;

  const CBScaffold({
    Key? key,
    required this.body,
    this.fullScreen = false,
    this.bottom = false,
    this.backgroundColor,
    this.statusBarColor,
    this.resizeToAvoidBottomInset = true,
    this.style,
    this.appBar,
    this.unFocusOnBGTap = true,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.belowSnackbar,
    this.extendBodyBehindAppBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completeBody =
        belowSnackbar != null ? Stack(children: [body, belowSnackbar!]) : body;

    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor ?? Colors.white,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: style ??
            SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: statusBarColor,
              systemNavigationBarColor:
                  Platform.isAndroid ? HexColor('121212') : null,
            ),
        child: SafeArea(
          top: !fullScreen,
          bottom: bottom,
          child: unFocusOnBGTap
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: completeBody,
                )
              : completeBody,
        ),
      ),
    );
  }
}
